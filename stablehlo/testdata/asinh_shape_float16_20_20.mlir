// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.sign %0 : tensor<20x20xf16>
    %3 = stablehlo.abs %0 : tensor<20x20xf16>
    %4 = stablehlo.constant dense<6.550400e+04> : tensor<20x20xf16>
    %5 = stablehlo.constant dense<2.558750e+02> : tensor<20x20xf16>
    %6 = stablehlo.compare  GE, %3, %5 : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<20x20xi1>
    %7 = stablehlo.abs %0 : tensor<20x20xf16>
    %8 = stablehlo.log %7 : tensor<20x20xf16>
    %9 = stablehlo.constant dense<2.000000e+00> : tensor<20x20xf16>
    %10 = stablehlo.constant dense<6.933590e-01> : tensor<20x20xf16>
    %11 = stablehlo.add %8, %10 : tensor<20x20xf16>
    %12 = stablehlo.abs %0 : tensor<20x20xf16>
    %13 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf16>
    %14 = stablehlo.compare  LE, %12, %13 : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<20x20xi1>
    %15 = stablehlo.abs %0 : tensor<20x20xf16>
    %16 = stablehlo.abs %0 : tensor<20x20xf16>
    %17 = stablehlo.abs %0 : tensor<20x20xf16>
    %18 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf16>
    %19 = stablehlo.abs %0 : tensor<20x20xf16>
    %20 = stablehlo.abs %0 : tensor<20x20xf16>
    %21 = stablehlo.multiply %19, %20 : tensor<20x20xf16>
    %22 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf16>
    %23 = stablehlo.add %21, %22 : tensor<20x20xf16>
    %24 = stablehlo.sqrt %23 : tensor<20x20xf16>
    %25 = stablehlo.add %18, %24 : tensor<20x20xf16>
    %26 = stablehlo.divide %17, %25 : tensor<20x20xf16>
    %27 = stablehlo.multiply %16, %26 : tensor<20x20xf16>
    %28 = stablehlo.add %15, %27 : tensor<20x20xf16>
    %29 = stablehlo.log_plus_one %28 : tensor<20x20xf16>
    %30 = stablehlo.abs %0 : tensor<20x20xf16>
    %31 = stablehlo.abs %0 : tensor<20x20xf16>
    %32 = stablehlo.abs %0 : tensor<20x20xf16>
    %33 = stablehlo.multiply %31, %32 : tensor<20x20xf16>
    %34 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf16>
    %35 = stablehlo.add %33, %34 : tensor<20x20xf16>
    %36 = stablehlo.sqrt %35 : tensor<20x20xf16>
    %37 = stablehlo.add %30, %36 : tensor<20x20xf16>
    %38 = stablehlo.log %37 : tensor<20x20xf16>
    %39 = stablehlo.select %14, %29, %38 : tensor<20x20xi1>, tensor<20x20xf16>
    %40 = stablehlo.select %6, %11, %39 : tensor<20x20xi1>, tensor<20x20xf16>
    %41 = stablehlo.multiply %2, %40 : tensor<20x20xf16>
    %42 = stablehlo.custom_call @check.eq(%41, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %42 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x003B9545D140253D19C10DC153B989C11CC373C0C9C1B3C53D41493BBBBEACC534C6EBB8D02F2CB82B3DC4C4C1C5FD35E0242D448942483F233833B642407EB116363CABA53BB137A7C0B8346EBBE0400A4404BCE2C06FB12ABA85398D411DC2B9285F4821BBD83DCBBB7BB093C61DA829B739401D45C1BD08410FBF8EB2B6BD0A41E7BBBA40203374448CBCEEC1E03911C6863B5E443344A032A4BF2A428DC3F3BFE1C62B41BF3CCCBD6742673B9F45473EAF4239461E430045CE3F9A34A5C375BC57BF81C445BCA9448FB585C4D2BD6C3CEE3CD43E03B9C9425CB8E93F43C4C1371A4435BCE2C59D347F44B738472C5540E843324252BE133DC3427A34A2BC864101450CB99240B03C53BBD8BEF93E98C2003E1140E6BC3DC0B9441A3D80BEF9BF3FC801BBC2C0E441C1C4B6C46D453A3C2BC40A382EC4AE42E33E4DBEB63C29443B41C7B9FCC1C6C2FC3E01BB124229BEC5C4A8C499351D3F64B1C644CABDF12C1D415636FEB87441B7B882436545F02E05C004C553C3A6C0F13876471E3ED943E63DC243194308B6B441FFC378BFA045DF4215C0E341FB430C33ECC1F04499C5D339463DFAC055B63CC3D6C138BBE53764B4C52A19BCF33207C4864286350D42B33C3A3F66BDFAB97ABB10C076355E3C88BEDEAA4CB976429538FC429740BAC1953B653F10C4BF4095BBE8C16FBACC3D863B0FC71544FFB79A42F7B8FF43663E5ABB58B9C7324C46D7BE4341C7C5AAC46EBEFAC3DFBF2E418FBDB32A743F3036AA3BE243E7A5B341163A4735D2B7AA3A9E407AB41FC57EBB2DBBAD43ECBE48C52741D6B960BFCD3EF83E0B411E4312BBA8B882C07644093CEB46FFADB83B9941DDC08DC003365BBF1C418DC58BB58DC26EC0CC33FE3D4B3512466636FE39D54482365FC00A41253FA6C77B424642FFC330C40C41B1C406415F29BC3E41C499C41F44FDC0F4C5DB40FAC21F3422434DBF7D40EFC42D3C9ABB143E61404EADA04486C5263F63BA9E401240DBBE72B464C786B6DB3ED74094346FBC2433C7417444B83905420245603BF83B4CB9DBC041C5B53E1CBD134434C5ECC5CD3A8CC306C64D40C44190C172BE423C9C445FC5644A3DC3ACBE8CBF33C75344A43F6EBE"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x523AD740733E473CAABEA1BEFFB8F8BEECBF29BE23BFE2C0C33E893A2BBDDFC00DC1A7B8CB2F01B84B3C88C0E7C0DA35E02446409A3F713DF1370EB6003E77B1F2353BABCD3A6B3753BEA734A4BA7E3E364014BB80BE68B1ADB92739FB3E58BFB828BA416BBAB13CE8BA77B02AC11DA8F0B6F83DAB40A4BC9D3E55BD82B29EBC9E3EFBBA623E12336640CEBB3BBF713902C1B53A5C40494094329CBD603F14C0C0BD41C1B63E083CABBC853F9E3ADB40EE3CAF3F0E41EE3FA040AF3D8A341AC0AEBB78BD6CC06EBB7C4074B56DC0AEBCA33B263C383DBBB8BE3F2BB8BC3D50C07A373D4058BBF2C08D346B407A38472C103E2B40653FF4BC3C3CBB3F6B34E9BBF63EA040C2B8423EFA3B90BA39BD4B3DA2BFC73CD53D20BCFBBD8340413C0CBDC3BDACC153BA68BE343F87C082C0C9405E3B45C0C53746C0AF3F3F3DF2BC023C4440C23E5DB944BFBDBF4C3D53BA513FDEBC88C07CC07D355D3D5EB18940A9BCF02CAC3E2F36B7B8EA3E7AB81140C640ED2ECBBDA1C005C052BEAC386A41D83C2740B93C2140EA3FE5B5153F30C088BDDB40CB3FD9BD343F2F40FE3239BF9A40D9C067395C3C93BE2CB6FEBF2BBF7DBA9B3757B4C42A31BBE53234C0973F6B354E3FFF3B6A3D6FBC87B9AEBAD5BD5C358F3B10BDDDAAF8B88E3F5C38DB3F463E19BFBF3A7E3D38C0663EBFBA37BFE4B9AB3CB53A4EC13A40B1B7A33FB1B83040FF3C96BA03B9BB32144139BDC73EE9C07DC003BD2FC0B8BDB93E87BCB22A863D0B36D03A2940E6A5143F9D39303589B7113A4B3E6BB4ACC0B0BA74BA1C4044BDBBC0B33E69B97CBD343D493D9F3EEE3F60BA6DB835BE67401A3B4441FDADDB3A033F7DBE3DBEDF357ABDAB3ED4C070B59CBF25BEB933C63C333502413C368A398F40573618BE9E3E603D77C1913F723F30C047C0A03E80C09B3E5F292B3D4FC076C03F4094BEF8C07B3EDABF1434EF3F73BD313E99C04B3BC4BAD33C193E4CAD7940D2C0613DDAB94B3ED73D3CBD64B465C15DB63C3D783E8434A6BB1633213F66405139493FA040993A083BF8B87BBEB9C0283D42BC3940B4C0F5C02B3A14C0FEC0093E1F3FFCBE05BD683B7740C4C07C42FEBF23BD92BD58C157409C3D03BD"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}

