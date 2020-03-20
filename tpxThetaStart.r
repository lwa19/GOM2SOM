structure(list("tpxThetaStart", list(function (X, theta, omega, 
    K) 
{
    R <- tpxResids(X, theta = theta, omega = omega, nonzero = TRUE)
    X$v <- R$e * (R$r > 3) + 1/ncol(X)
    Kpast <- ncol(theta)
    Kdiff <- K - Kpast
    if (Kpast != ncol(omega) || Kpast >= K) {
        stop("bad K in tpxThetaStart")
    }
    initheta <- normalize(Kpast * theta + rowMeans(theta), byrow = FALSE)
    n <- nrow(X)
    ki <- matrix(1:(n - n%%Kdiff), ncol = Kdiff)
    for (i in 1:Kdiff) {
        initheta <- cbind(initheta, (col_sums(X[ki[, i], ]) + 
            1/ncol(X))/(sum(X[ki[, i], ]) + 1))
    }
    return(initheta)
}), "namespace:maptpx", FALSE, FALSE), .Names = c("name", "objs", 
"where", "visible", "dups"), class = "getAnywhere")

