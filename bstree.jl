module bstree

struct bst_empty
end

struct bst_node{T}
    data::T
    left::Union{bst_node{T}, bst_empty}
    right::Union{bst_node{T}, bst_empty}
end
   

function Base.in(item::T, tree::bst_node{T}) where {T}
    if item < tree.data
        item in tree.left
    elseif item > tree.data
        item in tree.right
    else
        true
    end
end

function Base.in(item, tree::bst_empty)
    false
end

function find_succ(root::bst_node{T}) where {T}
    function find_succ_helper(root::bst_node{T})
        if typeof(root.left) == bst_empty
            root
        else
            find_succ_helper(root.left)
        end
    end
    find_succ_helper(root.right)
end

function delete(item::T, root::bst_node{T}) where {T}
    if item < root.data
        bst_node(root.data, delete(item, root.left), root.right)
    elseif item > root.data
        bst_node(root.data, root.left, delete(item, root.right))
    elseif typeof(root.left) == bst_empty # Replace this node with right child
        root.right
    elseif typeof(root.right) == bst_empty # Replace this node with left child
        root.left
    else # This is an internal node
        # Traverse tree to find the successor of this node
        succ = find_succ(root)
        # Copy data from successor into target node, and replace
        # the right subtree with a copy with the successor deleted
        bst_node(succ.data, root.left, delete(succ.data, root.right))
    end
end

struct bst_preorder{T}
    root::bst_node{T}
end

struct bst_inorder{T}
    root::bst_node{T}
end

struct bst_postorder{T}
    root::bst_node{T}
end

struct bst_levelorder{T}
    root::bst_node{T}
end

function Base.iterate(iter::bst_levelorder{T}) where {T}
    q = Array{bst_node{T}}(undef, 50)
    q[1] = iter.root
    Base.iterate(iter, (2, 1, q))
end

function Base.iterate(iter::bst_levelorder{T}, state::Tuple{Int64, Int64, Array{bst_node{T}}}) where {T}
    front = state[1]
    back = state[2]
    q = state[3]

    if front == back
        return nothing
    else
        it = q[back]
        back += 1

        if typeof(it.left) != bst_empty
            q[front] = it.left
            front += 1
        end

        if typeof(it.right) != bst_empty
            q[front] = it.right
            front += 1
        end

        return (it.data, (front, back, q))
    end
end

function Base.iterate(iter::bst_postorder{T}) where {T}
    up = Array{Tuple{bst_node{T}, Int64}}(undef, 50)
    up[1] = (iter.root, 0)
    Base.iterate(iter, (2, up))
end

function Base.iterate(iter::bst_postorder{T}, state::Tuple{Int64, Array{Tuple{bst_node{T}, Int64}}}) where{T}
    top = state[1]
    up = state[2]

    if top == 1
        return nothing
    end

    while top != 1
        top -= 1
        it = up[top]
        
        if it[2] == 0
            it = (it[1], 1)
            up[top] = it
            top += 1
            
            if typeof(it[1].left) != bst_empty
                up[top] = (it[1].left, 0)
                top += 1
            end
        elseif it[2] == 1
            it = (it[1], 2)
            up[top] = it
            top += 1
            if typeof(it[1].right) != bst_empty
                up[top] = (it[1].right, 0)
                top += 1
            end
        else
            return (it[1].data, (top, up))
        end
    end
end

function Base.iterate(iter::bst_inorder{T}) where {T}
    up = Array{bst_node{T}}(undef, 50)
    Base.iterate(iter, (-1, false, up))
end

function Base.iterate(iter::bst_inorder{T}, state::Tuple{Int64, Bool, Array{bst_node{T}}}) where {T}
    top = state[1]
    which_loop = state[2]
    up = state[3]
    it = iter.root
    if top == 0
        return nothing
    elseif top == -1
        top = 1
    else
        it = up[top]
    end

    if !which_loop
        while typeof(it) != bst_empty
            if typeof(it.right) != bst_empty
                up[top] = it.right
                top += 1
            end
            
            up[top] = it
            top +=1
            it = it.left
        end
        
        top -= 1
        it = up[top]
    end
    
    if top != 1 && typeof(it.right) == bst_empty
        (it.data, (top-1, true, up))
    else
        (it.data, (top-1, false, up))
    end
end

function Base.iterate(iter::bst_preorder{T}) where {T}
    up = Array{bst_node{T}}(undef, 50)
    up[1] = iter.root
    Base.iterate(iter, (2, up))
end

function Base.iterate(iter::bst_preorder{T}, state::Tuple{Int64, Array{bst_node{T}}}) where {T}
    top = state[1]
    up = state[2]
    if top == 1
        nothing
    else
        top -= 1
        it = up[top]

        if typeof(it.right) != bst_empty
            up[top] = it.right
            top += 1
        end

        if typeof(it.left) != bst_empty
            up[top] = it.left
            top += 1
        end
        (it.data, (top, up))
    end
end

function preorder_r(root::bst_node{T}) where {T}
    println(root.data)
    preorder_r(root.left)
    preorder_r(root.right)
end

function preorder_r(::bst_empty) end

function inorder_r(root::bst_node{T}) where {T}
    inorder_r(root.left)
    println(root.data)
    inorder_r(root.right)
end

function inorder_r(::bst_empty) end

function postorder_r(root::bst_node{T}) where {T}
    postorder_r(root.left)
    postorder_r(root.right)
    println(root.data)
end

function postorder_r(::bst_empty) end

function insert(item::T, root::bst_node{T}) where {T}
    if item < root.data
        bst_node(root.data, insert(item, root.left), root.right)
    elseif item > root.data
        bst_node(root.data, root.left, insert(item, root.right))
    else
        root
    end
end

function insert(item::T, root::bst_empty) where {T}
    bst_node(item, bst_empty(), bst_empty())
end
end
