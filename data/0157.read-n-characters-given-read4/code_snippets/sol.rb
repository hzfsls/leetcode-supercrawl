# The read4 API is already defined for you.
# Below is an example of how the read4 API can be called.
# file = File.new("abcdefghijk") File is "abcdefghijk", initially file pointer (fp) points to 'a'
# buf4 = [' '] * 4 Create buffer with enough space to store characters
# read4(buf4) # read4 returns 4. Now buf = ['a','b','c','d'], fp points to 'e'
# read4(buf4) # read4 returns 4. Now buf = ['e','f','g','h'], fp points to 'i'
# read4(buf4) # read4 returns 3. Now buf = ['i','j','k',...], fp points to end of file

# @param {List[str]} buf
# @param {int} n
# @return {int}
def read(buf, n)
    
end