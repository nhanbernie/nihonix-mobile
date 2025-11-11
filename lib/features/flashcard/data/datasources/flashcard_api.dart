library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/create_folder_request.dart';
import '../models/create_folder_response.dart';
import '../models/flashcard_folder_model.dart';
import '../models/get_folders_response.dart';

part 'flashcard_api.g.dart';

@RestApi()
abstract class FlashcardApi {
  factory FlashcardApi(Dio dio, {String? baseUrl}) = _FlashcardApi;

  @POST('/flashcard-folders')
  Future<CreateFolderResponse> createFolder(
    @Body() CreateFolderRequest request,
  );

  @GET('/flashcard-folders')
  Future<GetFoldersResponse> getFolders();

  @GET('/flashcard-folders/{id}')
  Future<FlashcardFolderModel> getFolderById(
    @Path('id') String id,
  );

  @PUT('/flashcard-folders/{id}')
  Future<FlashcardFolderModel> updateFolder(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @DELETE('/flashcard-folders/{id}')
  Future<void> deleteFolder(
    @Path('id') String id,
  );
}
