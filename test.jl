import bstree

function build_tree()
    tree = bstree.insert(5, bstree.bst_empty())
    
    for i in [3, 2, 7, 6, 8]
        tree = bstree.insert(i, tree)
    end
    tree
end

function test()
    tree = build_tree()
    order = bstree.bst_preorder(tree)
    for i in order
        println(i)
    end

    println()

    order = bstree.bst_inorder(tree)
    for i in order
        println(i)
    end

    println()

    order = bstree.bst_postorder(tree)
    for i in order
        println(i)
    end

    println()

    order = bstree.bst_levelorder(tree)
    for i in order
        println(i)
    end

    println()

    for i in tree
        println(i)
    end

    println()

    println(length(bstree.bst_preorder(tree)))
end
