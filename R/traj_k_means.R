#' Trajectory Clustering
#'  Clustering Algorithm: k means
#'  Representative trajectory: cubic spline
#'  Distance Metric: MSE
#'
#' @description
#'
#' `traj_k_means()` defines a model that fits clusters based on a distance to
#' a "centroid", which for this model is a fitted cubic spline.
#'
#'
#'
#' ask about this
#' There are different ways to fit this model, and the method of estimation is
#' chosen by setting the model engine. The engine-specific pages for this model
#' are listed below.
#'
#' use clustra and kml?
#'
#'
#'
#' - \link[=details_traj_k_means_clustra]{clustra}
#'
#' @param mode A single character string for the type of model. The only
#'   possible value for this model is "partition".
#' @param engine A single character string specifying what computational engine
#'   to use for fitting. Possible engines are listed below. The default for this
#'   model is `"clustra"`.
#'
#' #param fit A single character string specifying what model or method is
#'   utilized to create a trajectory that is used to represent
#'   each identified cluster. As of right now, the only supported
#'   model is "cubic spline".
#' #param algorithm A single character string specifying the algorithm
#'   used to cluster different trajectories. As of right now, the only
#'   algorithm supported is "kmeans".
#' #param distance A single character string specifying the
#'   distance metric used to determine how similar or dissimilar two
#'   different trajectories are from one another. As for right now, the only
#'   supported distance metric is "MSE".
#'
#' @param num_clusters Positive integer, number of clusters in model (optional?).
#'
#' @details
#'
#' ## What does it mean to predict?
#'
#' For a K-means model, each cluster is defined by a location in the predictor
#' space. Therefore, prediction in tidyclust is defined by calculating which
#' cluster "centroid" an observation is closest to.
#' Under the context of trajectory clustering, a "centroid" is defined
#' as the trajectory that is representative of a specific cluster.
#' A representative trajectory for this model is a cubic
#' spline fitted to all of the trajectories in a cluster.
#'
#' @return A `traj_k_means` cluster specification.
#'
#' @examples
#' # Show all engines
#' modelenv::get_from_env("traj_k_means")
#'
#' traj_k_means()
#' @export
traj_k_means <-
  function(
    mode = "partition",
    engine = "clustra",
    num_clusters = NULL
  ) {
    args <- list(
      num_clusters = enquo(num_clusters)
    )

    new_cluster_spec(
      "traj_k_means",
      args = args,
      eng_args = NULL,
      mode = mode,
      method = NULL,
      engine = engine
    )
  }

#' @export
print.traj_k_means <- function(x, ...) {
  cat("K Means Trajectory Clustering Specification (", x$mode, ")\n\n", sep = "")
  model_printer(x, ...)

  if (!is.null(x$method$fit$args)) {
    cat("Model fit template:\n")
    print(show_call(x))
  }

  invisible(x)
}

######## NEEDED / ORDER?
#' @export
translate_tidyclust.traj_k_means <- function(x, engine = x$engine, ...) {
  x <- translate_tidyclust.default(x, engine, ...)
  x
}
########

# ------------------------------------------------------------------------------

#' @method update traj_k_means
#' @rdname tidyclust_update
#' @export
update.traj_k_means <- function(
    object,
    parameters = NULL,
    num_clusters = NULL,
    fresh = FALSE,
    ...
) {
  eng_args <- parsnip::update_engine_parameters(
    object$eng_args,
    fresh = fresh,
    ...
  )

  if (!is.null(parameters)) {
    parameters <- parsnip::check_final_param(parameters)
  }
  args <- list(
    num_clusters = enquo(num_clusters)
  )

  args <- parsnip::update_main_parameters(args, parameters)

  if (fresh) {
    object$args <- args
    object$eng_args <- eng_args
  } else {
    null_args <- map_lgl(args, null_value)
    if (any(null_args)) {
      args <- args[!null_args]
    }
    if (length(args) > 0) {
      object$args[names(args)] <- args
    }
    if (length(eng_args) > 0) {
      object$eng_args[names(eng_args)] <- eng_args
    }
  }

  new_cluster_spec(
    "traj_k_means",
    args = object$args,
    eng_args = object$eng_args,
    mode = object$mode,
    method = NULL,
    engine = object$engine
  )
}

# # ----------------------------------------------------------------------------

#' @export
check_args.traj_k_means <- function(object) {
  args <- lapply(object$args, rlang::eval_tidy)

  if (all(is.numeric(args$num_clusters)) && any(args$num_clusters < 0)) {
    cli::cli_abort("The number of centers should be >= 0.")
  }

  invisible(object)
}

######## NEEDED / ORDER?
#' @export
translate_tidyclust.traj_k_means <- function(x, engine = x$engine, ...) {
  x <- translate_tidyclust.default(x, engine, ...)
  x
}
########

# ------------------------------------------------------------------------------
