/**
 * Definition for node.
 * class Node {
 *     val: number
 *     children: Node[]
 *     constructor(val?: number) {
 *         this.val = (val===undefined ? 0 : val)
 *         this.children = []
 *     }
 * }
 */

class Codec {
  	constructor() {
        
    }
    
    // Encodes a tree to a single string.
    serialize(root: Node | null): string {
        
    };
	
    // Decodes your encoded data to tree.
    deserialize(data: string): Node | null {
        
    };
}

// Your Codec object will be instantiated and called as such:
// Codec codec = new Codec();
// codec.deserialize(codec.serialize(root));