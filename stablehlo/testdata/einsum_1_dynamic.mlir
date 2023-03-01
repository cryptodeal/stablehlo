// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x4x5xf32> {mhlo.sharding = ""}, %arg2: tensor<?x5x6xf32> {mhlo.sharding = ""}) -> tensor<?x4x6xf32> {
    %0 = call @_einsum(%arg0, %arg1, %arg2) : (tensor<i64>, tensor<?x4x5xf32>, tensor<?x5x6xf32>) -> tensor<?x4x6xf32>
    return %0 : tensor<?x4x6xf32>
  }
  func.func private @_einsum(%arg0: tensor<i64>, %arg1: tensor<?x4x5xf32>, %arg2: tensor<?x5x6xf32>) -> tensor<?x4x6xf32> {
    %0 = "stablehlo.dot_general"(%arg1, %arg2) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [1]>} : (tensor<?x4x5xf32>, tensor<?x5x6xf32>) -> tensor<?x4x6xf32>
    return %0 : tensor<?x4x6xf32>
  }
}

