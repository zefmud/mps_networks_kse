create_graph <- function(edges, vertices) {
    edges <- edges %>% 
        filter(init_fullname.x %in% vertices$full_name,
               init_fullname.y %in% vertices$full_name)
    v_in_edges <-edges %>% 
        gather(key = vert_type, value = vertice, init_fullname.x:init_fullname.y) %>% 
        select(vertice) %>% 
        distinct() %>% 
        pull()
    vertices <- vertices %>% 
        filter(full_name %in% v_in_edges)

    g <- graph_from_data_frame(edges, vertices = vertices)
    g
}

mps_force_network <- function(edges, vertices) {
    g <- create_graph(edges, vertices)
    network <- igraph_to_networkD3(g, group = get.vertex.attribute(g, "unit_name"))
    network$nodes$size <- get.vertex.attribute(g, "bills_number") / max(get.vertex.attribute(g, "bills_number")) * 100
    forceNetwork(Links = network$links, Nodes = network$nodes, Source = "source", Target = "target", 
                 NodeID = "name", Group = "group", Nodesize = "size", legend = TRUE, opacity = 0.9, fontSize = 13, 
                 bounded = TRUE, charge = -15)
}