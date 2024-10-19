#' Following https://mrc-ide.github.io/individual/articles/API.html

#' Variables define state, and represent any attribute of an individual
#' 
#' individual::CategoricalVariable
#' Mutually exclusive categories e.g. S, I, R
#' Uses Bitset
#' 
#' individual::IntegerVariable
#' Technically unbounded (or really big)
#' Does not use Bitset
#' 
#' individual::DoubleVariable
#' Does not use Bitset
#' 
#' Processes are functiosn which are called on each time-step with a single argument, t
#' Implemented as closures i.e. able to access data not included in the function argument

bernoulli_process <- function(variable, from, to, rate) {
  function(t) {
    variable$queue_update(
      to,
      variable$get_index_of(from)$sample(rate)
    )
  }
}
