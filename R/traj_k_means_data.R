# nocov start

make_traj_k_means <- function() {
  modelenv::set_new_model("traj_k_means")

  modelenv::set_model_mode("traj_k_means", "partition")

  # ----------------------------------------------------------------------------

  modelenv::set_model_engine("traj_k_means", "partition", "clustra")
  modelenv::set_dependency(
    model = "k_means",
    mode = "partition",
    eng = "clustra",
    pkg = "clustra"
  )
  modelenv::set_dependency(
    model = "k_means",
    mode = "partition",
    eng = "clustra",
    pkg = "tidyclust"
  )

  modelenv::set_fit(
    model = "traj_k_means",
    eng = "clustra",
    mode = "partition",
    value = list(
      interface = "matrix",
      data = c(x = "data"),
      protect = c("x", "centers"),
      func = c(pkg = "tidyclust", fun = ".traj_k_means_fit_clustra"),
      defaults = list()
    )
  )

  modelenv::set_encoding(
    model = "traj_k_means",
    eng = "clustra",
    mode = "partition",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = TRUE,
      remove_intercept = TRUE,
      allow_sparse_x = FALSE
    )
  )

  modelenv::set_model_arg(
    model = "traj_k_means",
    eng = "clustra",
    exposed = "num_clusters",
    original = "k",
    func = list(pkg = "dials", fun = "num_clusters"),
    has_submodel = TRUE
  )

  modelenv::set_pred(
    model = "traj_k_means",
    eng = "stats",
    mode = "partition",
    type = "cluster",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = ".traj_k_means_predict_clustra"),
      args = list(
        object = rlang::expr(object$fit),
        new_data = rlang::expr(new_data)
      )
    )
  )
}
  # ----------------------------------------------------------------------------

# nocov end
