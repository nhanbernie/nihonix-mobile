import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:nihonix/core/network/providers.dart';
import 'package:nihonix/core/network/http_exceptions.dart';

/// Example screen demo cách sử dụng API với AuthInterceptor
///
/// Screen này demo:
/// - Gọi authenticated API
/// - Xử lý auto refresh token
/// - Xử lý các loại errors
class ProfileExampleScreen extends ConsumerStatefulWidget {
  const ProfileExampleScreen({super.key});

  @override
  ConsumerState<ProfileExampleScreen> createState() =>
      _ProfileExampleScreenState();
}

class _ProfileExampleScreenState extends ConsumerState<ProfileExampleScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);

      // AuthInterceptor sẽ tự động:
      // 1. Gắn Bearer token vào request
      // 2. Kiểm tra network trước khi gửi
      // 3. Refresh token nếu nhận 401
      // 4. Retry nếu có lỗi tạm thời
      final response = await apiClient.dio.get('/users/me');

      setState(() {
        _userData = response.data as Map<String, dynamic>;
        _isLoading = false;
      });
    } on DioException catch (e) {
      String errorMessage = 'Đã xảy ra lỗi';

      // AuthInterceptor đã map sang custom exceptions
      if (e.error is NoInternetException) {
        errorMessage = 'Không có kết nối mạng';
      } else if (e.error is UnauthorizedException) {
        errorMessage = 'Phiên đăng nhập đã hết hạn';
        // onUnauthorized callback sẽ tự động navigate về login
      } else if (e.error is ForbiddenException) {
        errorMessage = 'Bạn không có quyền truy cập';
      } else if (e.error is NotFoundException) {
        errorMessage = 'Không tìm thấy dữ liệu';
      } else if (e.error is ServerException) {
        errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau';
      } else if (e.error is RequestTimeoutException) {
        errorMessage = 'Yêu cầu quá thời gian chờ';
      }

      setState(() {
        _error = errorMessage;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);

      // POST request cũng tự động có Bearer token
      final response = await apiClient.dio.put(
        '/users/me',
        data: {
          'name': 'Updated Name',
          'bio': 'Updated bio',
        },
      );

      setState(() {
        _userData = response.data as Map<String, dynamic>;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thành công!')),
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Đã xảy ra lỗi';

      if (e.error is NoInternetException) {
        errorMessage = 'Không có kết nối mạng';
      } else if (e.error is BadRequestException) {
        final exception = e.error as BadRequestException;
        errorMessage = exception.message;
      } else if (e.error is ServerException) {
        errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau';
      }

      setState(() {
        _error = errorMessage;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchUserData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchUserData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_userData == null) {
      return const Center(
        child: Text('Không có dữ liệu'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Data',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text('ID: ${_userData!['id']}'),
                  Text('Name: ${_userData!['name']}'),
                  Text('Email: ${_userData!['email']}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Update button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Cập nhật Profile'),
            ),
          ),
          const SizedBox(height: 24),

          // Info
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AuthInterceptor đang hoạt động:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('✓ Bearer token đã được gắn tự động'),
                  const Text('✓ Network check trước khi gửi'),
                  const Text('✓ Auto refresh token nếu hết hạn'),
                  const Text('✓ Retry với exponential backoff'),
                  const Text('✓ Custom exceptions thân thiện'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
