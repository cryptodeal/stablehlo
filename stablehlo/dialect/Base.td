/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.
   Copyright 2022 The StableHLO Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifndef STABLEHLO_DIALECT_BASE
#define STABLEHLO_DIALECT_BASE

include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// HLO type definitions.
//===----------------------------------------------------------------------===//

def HLO_Pred : TypeAlias<I1, "pred (AKA boolean or 1-bit integer)">;

// TODO(hinsu): Use signed integers instead of signless integer which is being
// used for legacy reasons.
def HLO_SInt : SignlessIntOfWidths<[4, 8, 16, 32, 64]>;
def HLO_UInt : UnsignedIntOfWidths<[4, 8, 16, 32, 64]>;
def HLO_Int : AnyTypeOf<[HLO_SInt, HLO_UInt]>;

def HLO_Float : AnyTypeOf<[F8E4M3B11FNUZ, F8E4M3FN, F8E4M3FNUZ, F8E5M2,
                           F8E5M2FNUZ, F16, F32, F64, BF16]>;
def HLO_Float32Or64 : AnyTypeOf<[F32, F64]>;

def HLO_Complex : Complex<AnyTypeOf<[F32, F64]>>;

//===----------------------------------------------------------------------===//
// Quantized element type definitions.
//===----------------------------------------------------------------------===//

// TODO(b/230381284): Upstream width-specific uniform quantized element types.
class StableHLO_UniformQuantizedSignedInt<int width>
  : Type<Or<[
      And<[CPred<"$_self.isa<mlir::quant::UniformQuantizedType>()">,
           CPred<"$_self.cast<mlir::quant::UniformQuantizedType>()" #
                 ".getStorageTypeIntegralWidth() == " # width>,
           CPred<"$_self.cast<mlir::quant::UniformQuantizedType>()" #
                 ".isSigned()">]>,
      And<[CPred<"$_self.isa<mlir::quant::UniformQuantizedPerAxisType>()">,
           CPred<"$_self.cast<mlir::quant::UniformQuantizedPerAxisType>()" #
                 ".getStorageTypeIntegralWidth() == " # width>,
           CPred<"$_self.cast<mlir::quant::UniformQuantizedPerAxisType>()" #
                 ".isSigned()">]>]>,
    "QI" # width # " type"> {
  string name = "UniformQuantizedSignedInt";
  int bitwidth = width;
}

class StableHLO_UniformQuantizedUnsignedInt<int width>
  : Type<Or<[
      And<[CPred<"$_self.isa<mlir::quant::UniformQuantizedType>()">,
           CPred<"$_self.cast<mlir::quant::UniformQuantizedType>()" #
                 ".getStorageTypeIntegralWidth() == " # width>,
           CPred<"!$_self.cast<mlir::quant::UniformQuantizedType>()" #
                 ".isSigned()">]>,
      And<[CPred<"$_self.isa<mlir::quant::UniformQuantizedPerAxisType>()">,
           CPred<"$_self.cast<mlir::quant::UniformQuantizedPerAxisType>()" #
                 ".getStorageTypeIntegralWidth() == " # width>,
           CPred<"!$_self.cast<mlir::quant::UniformQuantizedPerAxisType>()" #
                 ".isSigned()">]>]>,
    "QUI" # width # " type"> {
  string name = "UniformQuantizedUnsignedInt";
  int bitwidth = width;
}

class StableHLO_UniformQuantizedSignedIntOfWidths<list<int> widths> :
    AnyTypeOf<!foreach(w, widths, StableHLO_UniformQuantizedSignedInt<w>),
              !interleave(widths, "/") # "-bit uniform quantized signed " #
              "integer">;

class StableHLO_UniformQuantizedUnsignedIntOfWidths<list<int> widths> :
    AnyTypeOf<!foreach(w, widths, StableHLO_UniformQuantizedUnsignedInt<w>),
              !interleave(widths, "/") # "-bit uniform quantized unsigned " #
              "integer">;

// Integer-based uniform quantized types. The definitions can be used to specify
// operand's tensor types.
def HLO_QuantizedSignedInt : StableHLO_UniformQuantizedSignedIntOfWidths<[4, 8, 16, 32]>;
def HLO_QuantizedUnsignedInt : StableHLO_UniformQuantizedUnsignedIntOfWidths<[4, 8, 16, 32]>;
def HLO_QuantizedInt :
    AnyTypeOf<[HLO_QuantizedSignedInt, HLO_QuantizedUnsignedInt]>;

// Token type.
def HLO_Token : Type<CPred<"$_self.isa<TokenType>()">, "token">;

// Any integer tensor types
def HLO_IntTensor : TensorOf<[HLO_Int]>;

// Any integer tensor type with rank 0 (i.e. representing a single integer).
def HLO_ScalarIntTensor : 0DTensorOf<[HLO_Int]>;

// Any floating-point tensor types
def HLO_FpTensor : TensorOf<[HLO_Float]>;

// 32 or 64 bits floating-point tensor types
def HLO_Fp32Or64Tensor : TensorOf<[HLO_Float32Or64]>;

// Any quantized integer tensor types
def HLO_QuantizedIntTensor : TensorOf<[HLO_QuantizedInt]>;

def HLO_PredTensor : TensorOf<[HLO_Pred]>;

def HLO_Tensor : TensorOf<[HLO_Float, HLO_Pred, HLO_Int, HLO_Complex, HLO_QuantizedInt]>;

def HLO_ComplexTensor : TensorOf<[HLO_Complex]>;

def HLO_Tuple : NestedTupleOf<[HLO_Tensor, HLO_Token]>;

def HLO_TensorOrToken : AnyTypeOf<[HLO_Tensor, HLO_Token]>;

def HLO_TensorOrTokenOrTuple : AnyTypeOf<[HLO_Tensor, HLO_Token, HLO_Tuple]>;

def HLO_DimensionValue : AnyTypeOf<[Index, HLO_Int]>;

// Dynamic representation of a shape vector as a tensor.
def HLO_DimensionTensor : 1DTensorOf<[HLO_DimensionValue]>;

//===----------------------------------------------------------------------===//
// HLO combined type definitions.
//===----------------------------------------------------------------------===//

// Any integer or floating-point tensor types
def HLO_IntOrFpTensor : TensorOf<[HLO_Int, HLO_Float]>;

// Any integer or predicate tensor types
def HLO_PredOrIntTensor : TensorOf<[HLO_Pred, HLO_Int]>;

// Any floating-point or complex tensor types
def HLO_FpOrComplexTensor : TensorOf<[HLO_Float, HLO_Complex]>;

// Any floating-point, complex or quantized tensor types
def HLO_FpComplexOrQuantizedIntTensor : TensorOf<[HLO_Float, HLO_Complex, HLO_QuantizedInt]>;

// Any int, floating-point, complex or quantized tensor types
def HLO_IntFpOrComplexOrQuantizedIntTensor : TensorOf<[HLO_Int, HLO_Float, HLO_Complex, HLO_QuantizedInt]>;

// Any pred, int or floating-point tensor types
def HLO_PredIntOrFpTensor : TensorOf<[HLO_Pred, HLO_Int, HLO_Float]>;

// Any pred, int, floating-point or quantized tensor types
def HLO_PredIntFpOrQuantizedTensor : TensorOf<[HLO_Pred, HLO_Int, HLO_Float, HLO_QuantizedInt]>;

//===----------------------------------------------------------------------===//
// HLO static shape type definitions.
//===----------------------------------------------------------------------===//

// In general, static shaped tensor constraints should be avoided unless
// it is for a legacy op which is only correct with static shapes.
def HLO_StaticShapeTensor : StaticShapeTensorOf<[
      HLO_Float, HLO_Pred, HLO_Int, HLO_Complex, HLO_QuantizedInt]>;

def HLO_StaticShapeTensorOrToken : AnyTypeOf<[HLO_StaticShapeTensor, HLO_Token]>;

def HLO_StaticShapeIntOrFpTensor : StaticShapeTensorOf<[HLO_Int, HLO_Float]>;

def HLO_StaticShapeIntFpOrComplexTensor :
  StaticShapeTensorOf<[HLO_Int, HLO_Float, HLO_Complex]>;

//===----------------------------------------------------------------------===//
// HLO traits
//===----------------------------------------------------------------------===//

class HLO_NativeOpTrait<string name> : NativeOpTrait<name> {
  let cppNamespace = "::mlir::hlo::OpTrait";
}

// An operation that is essentially element-wise but may implement broadcasting
// semantics.
def HLO_BroadcastingElementwise : HLO_NativeOpTrait<"BroadcastingElementwise">;

// This class adds property that the operation is commutative.
// Upstream IsCommutative has default folders, and StableHLO aims to have no
// default folders or canonicalizations.
def HLO_Commutative : HLO_NativeOpTrait<"IsCommutative">;

// Op has pairwise operand and result type matching: the number of operands
// must be equal to the number of results and the type of ith operand must
// match the type of ith result.
// TODO(b/195086460) Promote this to be an mlir trait and remove it here.
def HLO_PairwiseSameOperandAndResultType :
  HLO_NativeOpTrait<"PairwiseSameOperandAndResultType">;

// Op has operand and result types compatible with each other according to
// the rules implemented in isCompatibleForHloTypeInference, which account for
// special properties dynamism, quantization and sparsity.
def HLO_CompatibleOperandsAndResultType : TraitList<
  // TODO(b/231358795): Review the use of InferTypeOpInterface for ops that
  // support quantization or sparsity.
  [
    InferTypeOpInterface,
    DeclareOpInterfaceMethods<InferShapedTypeOpInterface, ["inferReturnTypeComponents"]>,
    HLO_NativeOpTrait<"CompatibleOperandsAndResultType">
  ]>;

def HLO_CompatibleOperandsAndResultElementType :
  HLO_NativeOpTrait<"CompatibleOperandsAndResultElementType">;

def HLO_BoundedAttrInterface : AttrInterface<"BoundedAttrInterface"> {
  let cppNamespace = "::mlir::hlo";

  let description = [{
    This interface is used for attributes that carry bounds for dimension sizes
    of an accompanying shaped type, e.g. when the attribute represents a
    RankedTensorType::getEncoding.
    The number of bounds is expected to be the same as the number of dimensions
    in the accompanying shaped type.
    For a static dimension, the corresponding bound is ShapedType::kDynamic.
    For a dynamic dimension, the corresponding bound is either known and is
    a non-negative number or unknown and is ShapedType::kDynamic.
  }];

  let methods = [InterfaceMethod<
    "Get the attribute's bounds",
    "::llvm::ArrayRef<int64_t>", "getBounds"
  >];
}

#endif // STABLEHLO_DIALECT_BASE
