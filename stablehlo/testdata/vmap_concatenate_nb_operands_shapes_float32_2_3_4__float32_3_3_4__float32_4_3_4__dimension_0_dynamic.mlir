// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x2x3x4xf32> {mhlo.sharding = ""}, %arg2: tensor<?x3x3x4xf32> {mhlo.sharding = ""}, %arg3: tensor<?x4x3x4xf32> {mhlo.sharding = ""}) -> tensor<?x9x3x4xf32> {
    %0 = stablehlo.concatenate %arg1, %arg2, %arg3, dim = 1 : (tensor<?x2x3x4xf32>, tensor<?x3x3x4xf32>, tensor<?x4x3x4xf32>) -> tensor<?x9x3x4xf32>
    return %0 : tensor<?x9x3x4xf32>
  }
}

