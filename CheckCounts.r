structure(list("CheckCounts", list(function (counts) 
{
    if (class(counts)[1] == "TermDocumentMatrix") {
        counts <- t(counts)
    }
    if (is.null(dimnames(counts)[[1]])) {
        dimnames(counts)[[1]] <- paste("doc", 1:nrow(counts))
    }
    if (is.null(dimnames(counts)[[2]])) {
        dimnames(counts)[[2]] <- paste("wrd", 1:ncol(counts))
    }
    empty <- slam::row_sums(counts) == 0
    if (sum(empty) != 0) {
        counts <- counts[!empty, ]
        cat(paste("Removed", sum(empty), "blank documents.\n"))
    }
    return(slam::as.simple_triplet_matrix(counts))
}, function (counts) 
{
    if (class(counts)[1] == "TermDocumentMatrix") {
        counts <- t(counts)
    }
    if (is.null(dimnames(counts)[[1]])) {
        dimnames(counts)[[1]] <- paste("doc", 1:nrow(counts))
    }
    if (is.null(dimnames(counts)[[2]])) {
        dimnames(counts)[[2]] <- paste("wrd", 1:ncol(counts))
    }
    empty <- row_sums(counts) == 0
    if (sum(empty) != 0) {
        counts <- counts[!empty, ]
        cat(paste("Removed", sum(empty), "blank documents.\n"))
    }
    return(as.simple_triplet_matrix(counts))
}), c("namespace:CountClust", "namespace:maptpx"), c(FALSE, FALSE
), c(FALSE, FALSE)), .Names = c("name", "objs", "where", "visible", 
"dups"), class = "getAnywhere")
