// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.abs %0 : tensor<20x20xbf16>
    %3 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xbf16>
    %4 = stablehlo.compare  GT, %2, %3 : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<20x20xi1>
    %5 = stablehlo.constant dense<0x7FC0> : tensor<20x20xbf16>
    %6 = stablehlo.log_plus_one %0 : tensor<20x20xbf16>
    %7 = stablehlo.negate %0 : tensor<20x20xbf16>
    %8 = stablehlo.log_plus_one %7 : tensor<20x20xbf16>
    %9 = stablehlo.subtract %6, %8 : tensor<20x20xbf16>
    %10 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xbf16>
    %11 = stablehlo.multiply %9, %10 : tensor<20x20xbf16>
    %12 = stablehlo.select %4, %5, %11 : tensor<20x20xi1>, tensor<20x20xbf16>
    %13 = stablehlo.custom_call @check.eq(%12, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %13 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x243FCE3F60C03240B5BE44BF87C021BFB23F9640AEC0283FBF3FB3BB0440A24058C0CF3F944018C0AD4032BF30BF313FCCBF79C0B1BF79C0A23F204078C08BBE003F35BF09C0FABEF7401DBC29C07F3B98BEA53FE4BF56C056400540BD408D3FB74083C0C0BF28C03C40A13F064036C091BF35C0E03F433F8340ADBFBE3F9440E7BE8E402F4016C0B9BF99BFE8BF9CBF0B3FB3BED6406ABFB33F33BEA6BEEBBF67C00BBE2DC0ABC0E43F1D3E91C0DBBF55C03FC089BF60C03B40F83D19C030C0E1BF73C0B73F8FC055C0B6BF053FB33F95BF8D3EEEBF2C3F774027C020C001C087C07340B9BF94C004401E403CBF08C0D63F9F3EE840F1BF3FBFA93F4AC0414000C0054078C0EBBE62400640B0C0EC3F01C1F23EBABFD4BF64C07A3F88C0233F69C0513F20C050C094C0124077BE6CC0B6C04A3F2C406CC0333FA8BE7040AD3FE2BF313F80C02640C9BFB63FEC3E39C083BF8B40D13F8EBF414015BFB3C06C40C3BEF13E6FC0653F1640C7BD5E40893F97BF2A3FB0BCE03FDB3E46C08D3F8BBF34BE41BF0E40D8BF84C06F4029C058BE9E3EE33E313F16C1B0BE5F3F85C024BE883FA7BF83C0BA40D73F0440CCBFC4C0A9C00BC0CFBF74409BC013400BC045406E4084BF3CC0D5BE01BFBA40EA3F6F40D3C0D73F243F99C00940F73D103F51402EC065BF64C0F03F9CBF7DBF2EC028C0C740643F9C40AC3F14C00C3FD03F39400E4025BFD940A3BE0DC0693F24C01CC041C060BFC3BF533F2EC0B240C2BFA8C0FEBFCC3F3740DFBC97C091C014C08040A8C0A13E7CC0BEBF8240F6BF484030402CC0A140F5BF84BEC7C02F400DC0B33F0A409A3D50401EC0AFBF39C0B23FC9BFDABF37C056402B3EF33F513E88403D3FC8C02D401C408AC0D4BE9EBF1940CBBF1540A23FCEBF0B404A3FC4C016C0A9BDC2BF193E37BE67C00AC00ABF3C40913F0E40E74067C021C02B4084C09B3FB2BEC23F494081C092C00DC03FC001C05DBFDE3F5EC0963F39BF81409940E63F5140B9BFF73D39401540FCBEBEBF1CC04E4001C052C0AFBE27BE4BC0E8BFB03F0F40A7C08E3F0BC077C016BF8AC06AC014C0C0C04340923F04C0303E423EA33FB2BF5A40313F0BC0BEC0D44007C0873F28C0"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x423FC07FC07FC07FBDBE82BFC07F3EBFC07FC07FC07F4A3FC07FB3BBC07FC07FC07FC07FC07FC07FC07F5CBF58BF5A3FC07FC07FC07FC07FC07FC07FC07F8EBE0C3F62BFC07F09BFC07F1DBCC07F7F3B9CBEC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07F803FC07FC07FC07FC07FFABEC07FC07FC07FC07FC07FC07FC07F1C3FBBBEC07FC6BFC07F35BEACBEC07FC07F0CBEC07FC07FC07F1E3EC07FC07FC07FC07FC07FC07FC07FF93DC07FC07FC07FC07FC07FC07FC07FC07F143FC07FC07F913EC07F513FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07F70BFC07FC07FA43EC07FC07F76BFC07FC07FC07FC07FC07FC07FFEBEC07FC07FC07FC07FC07F043FC07FC07FC07F0E40C07F413FC07F933FC07FC07FC07FC07F7CBEC07FC07F893FC07FC07F5E3FAEBEC07FC07FC07F5A3FC07FC07FC07FC07FFF3EC07FC07FC07FC07FC07FC07F2ABFC07FC07FCDBE033FC07FB93FC07FC8BDC07FC07FC07F4D3FB0BCC07FEA3EC07FC07FC07F36BE7BBFC07FC07FC07FC07FC07F5CBEA43EF43E5A3FC07FB8BEAB3FC07F26BEC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FC07FE3BE0EBFC07FC07FC07FC07FC07F423FC07FC07FF83D233FC07FC07FB9BFC07FC07FC07F24C0C07FC07FC07FB73FC07FC07FC07F1D3FC07FC07FC07F44BFC07FA9BEC07FC43FC07FC07FC07FADBFC07F963FC07FC07FC07FC07FC07FC07FC07FDFBCC07FC07FC07FC07FC07FA63EC07FC07FC07FC07FC07FC07FC07FC07FC07F87BEC07FC07FC07FC07FC07F9A3DC07FC07FC07FC07FC07FC07FC07FC07FC07F2C3EC07F543EC07F733FC07FC07FC07FC07FE2BEC07FC07FC07FC07FC07FC07FC07F893FC07FC07FA9BDC07F1A3E39BEC07FC07F1ABFC07FC07FC07FC07FC07FC07FC07FC07FC07FBABEC07FC07FC07FC07FC07FC07FC07FA7BFC07FC07FC07F6ABFC07FC07FC07FC07FC07FF83DC07FC07F0ABFC07FC07FC07FC07FC07FB6BE28BEC07FC07FC07FC07FC07FC07FC07FC07F2CBFC07FC07FC07FC07FC07FC07FC07F323E443EC07FC07FC07F5A3FC07FC07FC07FC07FC07FC07F"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}

