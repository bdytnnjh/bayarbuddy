# Scam Detection System - BayarBuddy

## Overview
Sistem deteksi scam otomatis yang melindungi pengguna dari transaksi mencurigakan dengan memantau perilaku panic button dan memberikan waktu tunggu keamanan sebelum approve transfer.

## Fitur Utama

### 1. **Security Wait Period (30 detik)**
- Saat user masuk ke halaman Confirm Transfer, button **Approve** otomatis di-disable selama 30 detik
- UI menampilkan countdown timer untuk memberi tahu user
- Tujuan: Memberi waktu user untuk berpikir dan memastikan transaksi legitimate

### 2. **Panic Button Detection**
- Jika user menekan button **Approve** lebih dari 3x selama waiting period (30 detik)
- Sistem otomatis mendeteksi sebagai "panic behavior" - kemungkinan user sedang di-intimidasi/scam
- Trigger notifikasi darurat ke semua Trusted Contacts

### 3. **Auto Lock Mechanism**
- Setelah scam terdeteksi, semua button (Approve, Reject, Help Me!) di-disable
- Transfer di-lock sampai mendapat response dari Trusted Contact
- Mencegah user melakukan approve dalam keadaan panic/dipaksa

### 4. **Scam Trigger History**
- Setiap kejadian scam detection disimpan di Firestore collection `scam_trigger_histories`
- Data tersimpan untuk audit trail dan analisis pattern
- Dapat di-resolve oleh user atau trusted contact

## Struktur Data

### Collection: `scam_trigger_histories`
```json
{
  "userId": "string",
  "transferId": "string",
  "recipientName": "string",
  "recipientWalletNumber": "string",
  "amount": 100.0,
  "triggerType": "multiple_approve_attempts",
  "approveAttempts": 3,
  "isResolved": false,
  "resolvedBy": "user | trusted_contact",
  "resolution": "approved | rejected | timeout",
  "triggeredAt": "Timestamp",
  "resolvedAt": "Timestamp | null"
}
```

### Trigger Types:
- `multiple_approve_attempts`: User mencoba approve 3+ kali saat waiting period
- `panic_button`: User menekan Help Me! button
- `help_request`: User eksplisit minta bantuan

## Flow Diagram

```
User masuk Confirm Transfer Screen
          ↓
[Waiting Period Start: 30s countdown]
          ↓
Button Approve = DISABLED
          ↓
User mencoba tekan Approve
          ↓
    Attempt Count++
          ↓
Attempts >= 3? ─NO→ Tampilkan snackbar "Please wait"
     │
     YES
     ↓
[SCAM DETECTED!]
     ↓
1. Create scam_trigger_history
2. Send alert ke Trusted Contacts
3. Lock all buttons
4. Tampilkan Red Alert Banner
     ↓
Waiting for Trusted Contact Response...
```

## Provider State Management

### ConfirmTransferProvider

**States:**
- `remainingSeconds` (int): Countdown timer
- `isWaitingPeriod` (bool): Apakah masih dalam waiting period
- `approveAttempts` (int): Jumlah percobaan approve
- `isScamDetected` (bool): Status scam detection
- `isWaitingTrustedResponse` (bool): Menunggu response dari trusted contact
- `canApprove` (bool): Apakah button approve bisa diklik
- `canReject` (bool): Apakah button reject bisa diklik

**Methods:**
- `startWaitingPeriod()`: Mulai countdown 30 detik
- `handleApproveAttempt()`: Track percobaan approve
- `resolveScamTrigger()`: Resolve scam incident
- `resetState()`: Reset semua state

## UI Components

### 1. Security Wait Period Banner (Orange)
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.orange.shade100,
    border: Border.all(color: Colors.orange, width: 2),
  ),
  child: Text('Security wait period: ${remainingSeconds}s remaining'),
)
```

### 2. Scam Alert Banner (Red)
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.red.shade100,
    border: Border.all(color: Colors.red, width: 2),
  ),
  child: Text('⚠️ SCAM ALERT\nSuspicious activity detected!'),
)
```

### 3. Approve Button States
- **Waiting Period**: "Wait {remainingSeconds}s" - DISABLED
- **Scam Detected**: "Locked" - DISABLED
- **Ready**: "Approve" - ENABLED

## Notification Data Payload

Saat scam terdeteksi, notifikasi dikirim dengan data:

```json
{
  "type": "scam_detection",
  "triggerType": "multiple_approve_attempts",
  "amount": "100.00",
  "recipientName": "John Doe",
  "recipientPhone": "+60123456789",
  "senderName": "User Name",
  "senderUid": "user123",
  "approveAttempts": 3,
  "scamTriggerId": "trigger_id_123",
  "timestamp": "2025-12-02T10:30:00.000Z"
}
```

## Repository Methods

### ScamTriggerHistoriesRepository

```dart
// Create new scam trigger
Future<String> createScamTrigger({
  required String userId,
  required String transferId,
  required String recipientName,
  required String recipientWalletNumber,
  required double amount,
  required String triggerType,
  required int approveAttempts,
});

// Get user's scam triggers
Future<List<ScamTriggerHistoryModel>> getUserScamTriggers(String userId);

// Get unresolved triggers
Future<List<ScamTriggerHistoryModel>> getUnresolvedScamTriggers(String userId);

// Resolve scam trigger
Future<void> resolveScamTrigger({
  required String historyId,
  required String resolvedBy,
  required String resolution,
});

// Stream scam triggers
Stream<QuerySnapshot<Map<String, dynamic>>> streamUserScamTriggers(String userId);
```

## Testing Checklist

### Manual Testing Steps:

1. **Normal Flow (No Scam)**
   - [ ] Masuk Confirm Transfer Screen
   - [ ] Verify banner orange muncul dengan countdown 30s
   - [ ] Verify button Approve disabled
   - [ ] Tunggu sampai countdown habis (0s)
   - [ ] Verify button Approve enabled
   - [ ] Tekan Approve → Transfer berhasil

2. **Scam Detection Flow**
   - [ ] Masuk Confirm Transfer Screen
   - [ ] Saat countdown masih jalan, tekan Approve 1x → Snackbar warning
   - [ ] Tekan Approve 2x → Snackbar warning
   - [ ] Tekan Approve 3x → Red Alert Banner muncul
   - [ ] Verify semua button disabled/locked
   - [ ] Check Firestore: `scam_trigger_histories` collection berisi entry baru
   - [ ] Check Trusted Contact: Terima notifikasi scam alert

3. **Button State Testing**
   - [ ] Waiting Period: Approve = disabled, text = "Wait Xs"
   - [ ] Scam Detected: Approve = disabled, text = "Locked"
   - [ ] Scam Detected: Reject = disabled
   - [ ] Scam Detected: Help Me! = disabled

4. **Provider Testing**
   - [ ] startWaitingPeriod() → remainingSeconds = 30
   - [ ] Timer countdown → remainingSeconds berkurang tiap detik
   - [ ] handleApproveAttempt() → approveAttempts increment
   - [ ] approveAttempts >= 3 → isScamDetected = true

## Backend Requirements

### API Endpoint untuk Scam Alert Notification
Backend harus support mengirim FCM notification dengan:
- **Priority**: `high`
- **Channel ID**: `bayarbuddy_help_request`
- **Full-Screen Intent**: true (untuk scam alert)

```json
{
  "to": "TRUSTED_CONTACT_FCM_TOKEN",
  "priority": "high",
  "notification": {
    "title": "🚨 SCAM ALERT: USER NAME MAY BE IN DANGER!",
    "body": "Suspicious activity detected! 3 attempts to approve RM 100 transfer. Urgent response needed!",
    "sound": "default",
    "android_channel_id": "bayarbuddy_help_request"
  },
  "data": {
    "type": "scam_detection",
    "triggerType": "multiple_approve_attempts",
    "amount": "100.00",
    "recipientName": "Scammer Name",
    "recipientPhone": "+60123456789",
    "senderName": "Victim Name",
    "senderUid": "victim_uid",
    "approveAttempts": 3,
    "scamTriggerId": "trigger_id_123",
    "timestamp": "2025-12-02T10:30:00.000Z"
  }
}
```

## Security Considerations

### 1. **False Positives**
- User mungkin genuine tapi bingung/salah tekan
- Solution: Berikan option untuk resolve sendiri atau timeout auto-resolve

### 2. **Scammer Bypass**
- Scammer bisa paksa user tunggu sampai 30 detik selesai
- Mitigation: Edukasi user untuk tekan "Help Me!" jika dipaksa

### 3. **Privacy**
- Semua scam trigger disimpan dengan encryption
- Hanya user dan trusted contact yang bisa akses data

### 4. **Performance**
- Timer menggunakan `Timer.periodic` dengan cleanup di dispose
- Firestore query di-index untuk performa optimal

## Future Enhancements

1. **AI Pattern Detection**
   - Analisis pattern transfer mencurigakan
   - Machine learning untuk deteksi anomaly

2. **Geolocation Verification**
   - Cross-check lokasi transfer dengan lokasi user biasa
   - Alert jika transfer dari lokasi unusual

3. **Behavioral Analytics**
   - Track waktu response user (terlalu cepat/lambat)
   - Analisis typing pattern untuk deteksi coercion

4. **Auto Block List**
   - Blacklist nomor wallet yang sering dilaporkan scam
   - Share blacklist antar komunitas user

## Troubleshooting

### Problem: Countdown tidak jalan
- **Cause**: Provider tidak di-initialize di initState
- **Fix**: Pastikan `provider.startWaitingPeriod()` dipanggil di initState

### Problem: Button tetap disabled setelah countdown habis
- **Cause**: Provider state tidak update
- **Fix**: Verify `notifyListeners()` dipanggil di timer callback

### Problem: Scam tidak terdeteksi setelah 3x approve
- **Cause**: `handleApproveAttempt()` tidak dipanggil
- **Fix**: Pastikan logic di `_handleApprove()` screen memanggil provider method

### Problem: Notifikasi tidak terkirim ke trusted contact
- **Cause**: Trusted contact tidak punya `linkedUserId`
- **Fix**: Ensure user menghubungkan trusted contact dengan user ID yang valid

## Code Examples

### Initialize Provider
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = Provider.of<ConfirmTransferProvider>(context, listen: false);
    provider.startWaitingPeriod();
  });
}
```

### Handle Approve Attempt
```dart
Future<void> _handleApprove(BuildContext context) async {
  final provider = Provider.of<ConfirmTransferProvider>(context, listen: false);
  
  if (provider.isWaitingPeriod) {
    await provider.handleApproveAttempt(
      userId: userUid,
      recipientName: widget.receiver.name,
      recipientWalletNumber: widget.receiver.walletNumber,
      amount: double.parse(widget.amount),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please wait ${provider.remainingSeconds} seconds')),
    );
    return;
  }
  
  // Proceed with normal approve flow
}
```

### Consume Provider State
```dart
Consumer<ConfirmTransferProvider>(
  builder: (context, confirmProvider, _) {
    return ElevatedButton(
      onPressed: confirmProvider.canApprove ? () => _handleApprove(context) : null,
      child: Text(
        confirmProvider.isWaitingPeriod
            ? 'Wait ${confirmProvider.remainingSeconds}s'
            : confirmProvider.isScamDetected
                ? 'Locked'
                : 'Approve',
      ),
    );
  },
)
```

## Kesimpulan

Sistem scam detection ini memberikan layer keamanan tambahan untuk melindungi user dari:
- Transfer paksa (intimidation/coercion)
- Panic button behavior (desperate approve attempts)
- Social engineering scams

Dengan kombinasi **waiting period**, **panic detection**, dan **trusted contact notification**, BayarBuddy dapat mencegah transaksi scam sebelum terlambat.

---

**Created**: December 2, 2025  
**Version**: 1.0  
**Author**: BayarBuddy Development Team
