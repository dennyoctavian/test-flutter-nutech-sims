1.  Arsitektur & Separation of Concerns

Masalah: Provider (business logic) menerima BuildContext langsung dan melakukan navigasi di dalamnya. Ini melanggar prinsip separation of concerns — provider
seharusnya hanya mengurus state, bukan UI logic.

// ❌ Sekarang (di user_provider.dart)
void getProfile(BuildContext context) async {
...
Navigator.pushReplacementNamed(context, "/login");
}

Solusi: Gunakan callback atau return result, lalu handle navigasi di widget layer.

// ✅ Lebih baik
Future<bool> getProfile() async {
status = Status.loading;
notifyListeners();
final response = await MemberService().getProfile();
if (response?.status == 0) {
user = response!.data!;
status = Status.success;
notifyListeners();
return true;
} else if (response?.status == 108) {
status = Status.unauthorized;
notifyListeners();
return false;
}
...
}

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

2. Duplikasi Code di Service Layer

Masalah: Setiap method di MemberService, TransactionService, InformationService punya error handling yang identik:

} catch (e) {
if (e is DioException) {
if (e.response != null) {
return XxxResponse.fromMap(e.response?.data);
}
}
return XxxResponse(status: 500, message: e.toString());
}

Solusi: Buat base service atau helper method:

class BaseService {
final dio = Dio();

    Future<T> safeCall<T>(
      Future<Response> Function() apiCall,
      T Function(Map<String, dynamic>) fromMap,
      T Function(String message) onError,
    ) async {
      try {
        final response = await apiCall();
        return fromMap(response.data);
      } on DioException catch (e) {
        if (e.response != null) {
          return fromMap(e.response!.data);
        }
        return onError(e.toString());
      } catch (e) {
        return onError(e.toString());
      }
    }

}

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

3. Dio Instance - Tidak Ada Interceptor / Singleton

Masalah: Setiap service membuat final dio = Dio() baru. Token ditambahkan manual di setiap request.

Solusi: Buat singleton Dio dengan interceptor:

class DioClient {
static final Dio \_dio = Dio(BaseOptions(baseUrl: Shared.url))
..interceptors.add(InterceptorsWrapper(
onRequest: (options, handler) async {
final token = await Session.getToken();
if (token != null) {
options.headers['Authorization'] = 'Bearer $token';
}
handler.next(options);
},
));

    static Dio get instance => _dio;

}

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

4. use_build_context_synchronously Warnings Diabaikan

Masalah: Banyak // ignore: use_build_context_synchronously di seluruh codebase. Ini bukan solusi, hanya menyembunyikan masalah.

Solusi: Cek mounted sebelum menggunakan context setelah async gap:

if (!mounted) return;
Navigator.pushReplacementNamed(context, "/login");

Atau lebih baik lagi, pindahkan navigasi keluar dari provider (lihat poin 1).

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

5. Typo di Nama File & Class

- splash_scereen.dart → seharusnya splash_screen.dart
- cutom_button.dart → seharusnya custom_button.dart
- isObsure → seharusnya isObscure
- confirPasswordController → seharusnya confirmPasswordController
- VisibiltyPrice → seharusnya VisibilityPrice

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

6. Future.delayed(Duration.zero, ...) Anti-pattern

Masalah: Di beberapa provider:

Future.delayed(Duration.zero, () {
notifyListeners();
});

Solusi: Gunakan WidgetsBinding.instance.addPostFrameCallback atau lebih baik, panggil provider di luar initState (gunakan WidgetsBinding atau pindahkan ke
didChangeDependencies).

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

7. Bottom Navigation Rebuild Seluruh Page

Masalah: Di BottomNavigationPage, setiap tab adalah instance baru yang dibuat di list. Setiap kali index berubah, semua page di-rebuild.

Solusi: Gunakan IndexedStack agar state page tetap terjaga:

body: IndexedStack(
index: value.currentIndex,
children: const [
HomePage(),
TopUpPage(),
TransactionPage(),
AccountPage(),
],
),

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

8. Hardcoded Strings

Masalah: URL API, pesan error, dan teks UI di-hardcode langsung.

Solusi:

- URL API → masukkan ke environment config (.env atau --dart-define)
- Teks UI → gunakan constant file atau localization
- Hardcoded status code 108 → buat constant static const int unauthorized = 108;

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

9. Tidak Ada Unit Test

Masalah: Hanya ada default widget_test.dart bawaan Flutter. Tidak ada test untuk service, provider, maupun widget.

Solusi: Tambahkan minimal:

- Unit test untuk provider logic
- Unit test untuk model serialization (fromMap/toMap)
- Widget test untuk halaman kritis (login, register)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

10. State Management Mixed Concern di UserProvider

Masalah: UserProvider handle profile, balance, topup, dan payment sekaligus. Ini terlalu besar (God class).

Solusi: Pisahkan:

- ProfileProvider → data user, update profile
- BalanceProvider → saldo, topup, payment

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

11. Memory Leak Potential

Masalah: Di LoginPage dan RegisterPage:

@override
void dispose() {
super.dispose(); // ← harus di akhir
emailController.dispose();
}

super.dispose() seharusnya dipanggil terakhir, bukan pertama.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

12. Network Image Tanpa Error Handling

Masalah: NetworkImage(e.bannerImage ?? "") — jika URL kosong atau invalid, app akan crash/error tanpa fallback.

Solusi: Gunakan CachedNetworkImage dengan placeholder dan error widget:

CachedNetworkImage(
imageUrl: e.bannerImage ?? "",
placeholder: (context, url) => CircularProgressIndicator(),
errorWidget: (context, url, error) => Icon(Icons.error),
)
