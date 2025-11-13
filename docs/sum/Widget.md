<!-- flutter -->

ScaffoldMessenger

BuildContext context (tree trong flutter) (như là 1 cái máy ảnh)



<!-- life cycle -->
initState
super.initState();
didChangeDependencies
dispose



<!-- state with river -->

ref.watch
ref.listen
ref.read (không hay dùng)
(hay dùng)

watch = subscribe + rebuild;
read = lấy 1 lần / gọi action;
listen = lắng nghe để làm side-effect (không rebuild).

emit
AuthNotifier.login là nơi emit (gán state = ...). UI gọi authNotifier.login(...) để bắt đầu quy trình; notifier thực hiện API và cập nhật state.

<!-- Dart -->

Username \_username = const Username.pure();
Password \_password = const Password.pure();


REMEMBER:
repository là interface thôi nhé: là abstract class
repositoryImpl là implement của interface
repositoryImpl gọi dataSource để lấy data
dataSource gọi api để lấy data

usecase nó gọi repository, nhưng repository nó chỉ là interface thôi, nó không hề biết implement là gì
nhưng khi chạy thực tế sẽ dùng implementation (AuthRepositoryImpl) đã được inject qua DI/provider

cơ chế từ usecase gọi lên repository thì DI của (riverpod) inject repositoryImpl vào usecase

khúc này check dễ hơn: cơ chế từ repositoryImpl gọi lên dataSource thì DI của (riverpod) inject dataSourceImpl vào repositoryImpl
cơ chế từ dataSourceImpl gọi lên api thì DI của (riverpod) inject api vào dataSourceImpl



Flow chuẩn Clean Architecture + Riverpod:

UI gọi hàm login (thường qua side-effect của Riverpod, ví dụ ref.read(authProvider.notifier).login(...)).
Provider (AuthNotifier) là nơi quản lý state và gọi method login.
Trong method login:
Gọi đến UseCase (qua DI/provider, ví dụ ref.read(loginUseCaseProvider)).
UseCase chỉ biết interface (AuthRepository), nên gọi hàm login của AuthRepository.
DI/Provider inject implementation (AuthRepositoryImpl) cho AuthRepository.
AuthRepositoryImpl nhận vào DataSource (AuthRemoteDataSource) qua constructor.
Khi gọi login, AuthRepositoryImpl gọi tiếp login của AuthRemoteDataSource.
AuthRemoteDataSource thực hiện HTTP request tới API (endpoint).
API trả về response (thường là JSON).
DataSource parse response thành model/domain entity (LoginResult, User, ...).
RepositoryImpl trả data lên cho UseCase.
UseCase trả data lên cho Provider.
Provider cập nhật lại state (user, token, error, ...).
UI tự động rebuild khi state thay đổi (nhờ Riverpod).