-spec trie_init_() -> any().
trie_init_() ->
  .

-spec trie_insert(Word :: unicode:unicode_binary()) -> any().
trie_insert(Word) ->
  .

-spec trie_count_words_equal_to(Word :: unicode:unicode_binary()) -> integer().
trie_count_words_equal_to(Word) ->
  .

-spec trie_count_words_starting_with(Prefix :: unicode:unicode_binary()) -> integer().
trie_count_words_starting_with(Prefix) ->
  .

-spec trie_erase(Word :: unicode:unicode_binary()) -> any().
trie_erase(Word) ->
  .


%% Your functions will be called as such:
%% trie_init_(),
%% trie_insert(Word),
%% Param_2 = trie_count_words_equal_to(Word),
%% Param_3 = trie_count_words_starting_with(Prefix),
%% trie_erase(Word),

%% trie_init_ will be called before every test case, in which you can do some necessary initializations.