// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x20x20xi64> {mhlo.sharding = ""}) -> tensor<?x20x20xi64> {
    %0 = stablehlo.abs %arg1 : tensor<?x20x20xi64>
    return %0 : tensor<?x20x20xi64>
  }
}

