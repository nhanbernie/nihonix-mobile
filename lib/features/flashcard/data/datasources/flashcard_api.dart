library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/create_folder_request.dart';
import '../models/create_folder_response.dart';
import '../models/update_folder_response.dart';
import '../models/flashcard_folder_model.dart';
import '../models/get_folders_response.dart';
import '../models/get_sets_response.dart';
import '../models/get_cards_response.dart';
import '../models/create_flashcard_request.dart';
import '../models/create_flashcard_response.dart';

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
  Future<UpdateFolderResponse> updateFolder(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @DELETE('/flashcard-folders/{id}')
  Future<void> deleteFolder(
    @Path('id') String id,
  );

  // Get all sets in a folder
  @GET('/flashcards/sets')
  Future<GetSetsResponse> getSetsInFolder(
    @Query('folderId') String folderId,
  );

  // Get all cards in a set
  @GET('/flashcards/sets/{setId}/cards')
  Future<GetCardsResponse> getCardsInSet(
    @Path('setId') String setId,
  );

  // Delete a flashcard set
  @DELETE('/flashcards/sets/{setId}')
  Future<void> deleteFlashcardSet(
    @Path('setId') String setId,
  );

  // Create flashcard set with cards
  @POST('/flashcards')
  Future<CreateFlashcardResponse> createFlashcard(
    @Body() CreateFlashcardRequest request,
  );
}
