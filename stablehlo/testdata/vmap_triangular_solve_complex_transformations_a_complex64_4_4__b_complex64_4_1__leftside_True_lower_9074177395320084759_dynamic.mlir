// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x4x4xcomplex<f32>> {mhlo.sharding = ""}, %arg2: tensor<?x4x1xcomplex<f32>> {mhlo.sharding = ""}) -> tensor<?x4x1xcomplex<f32>> {
    %0 = chlo.conj %arg1 : tensor<?x4x4xcomplex<f32>> -> tensor<?x4x4xcomplex<f32>>
    %1 = "stablehlo.triangular_solve"(%0, %arg2) {left_side = true, lower = false, transpose_a = #stablehlo<transpose NO_TRANSPOSE>, unit_diagonal = false} : (tensor<?x4x4xcomplex<f32>>, tensor<?x4x1xcomplex<f32>>) -> tensor<?x4x1xcomplex<f32>>
    return %1 : tensor<?x4x1xcomplex<f32>>
  }
}

