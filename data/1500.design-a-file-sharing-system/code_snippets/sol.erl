-spec file_sharing_init_(M :: integer()) -> any().
file_sharing_init_(M) ->
  .

-spec file_sharing_join(OwnedChunks :: [integer()]) -> integer().
file_sharing_join(OwnedChunks) ->
  .

-spec file_sharing_leave(UserID :: integer()) -> any().
file_sharing_leave(UserID) ->
  .

-spec file_sharing_request(UserID :: integer(), ChunkID :: integer()) -> [integer()].
file_sharing_request(UserID, ChunkID) ->
  .


%% Your functions will be called as such:
%% file_sharing_init_(M),
%% Param_1 = file_sharing_join(OwnedChunks),
%% file_sharing_leave(UserID),
%% Param_3 = file_sharing_request(UserID, ChunkID),

%% file_sharing_init_ will be called before every test case, in which you can do some necessary initializations.