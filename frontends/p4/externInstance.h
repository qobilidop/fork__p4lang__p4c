/*
Copyright 2013-present Barefoot Networks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#ifndef FRONTENDS_P4_EXTERNINSTANCE_H_
#define FRONTENDS_P4_EXTERNINSTANCE_H_

#include <optional>

#include "frontends/p4/parameterSubstitution.h"
#include "lib/cstring.h"

namespace P4::IR {
class ConstructorCallExpression;
class Expression;
class IAnnotated;
class PathExpression;
class Type_Extern;
class TypeMap;
template <typename T>
class Vector;
}  // namespace P4::IR

namespace P4 {

class ReferenceMap;
class TypeMap;

/**
 * ExternInstance is a utility class that allows you to gather information about
 * an expression that resolves to an extern instance.
 *
 * The name is in analogy to MethodInstance. It provides information about the
 * name of the extern instance, the underlying extern type, the arguments it was
 * instantiated with, and the annotations that we applied to it. It can gather
 * this information from either a reference to a named instance, or from an
 * expression which constructs an anonymous instance.
 */
struct ExternInstance final {
    const std::optional<cstring> name;          // The instance's name, if any.
    const IR::Expression *expression;           // The original expression passed to resolve().
    const IR::Type_Extern *type;                // The type of the instance.
    const IR::Vector<IR::Type> *typeArguments;  // The instance's type arguments;
    const IR::Vector<IR::Argument> *arguments;  // The instance's constructor arguments.
    ParameterSubstitution substitution;         // Mapping from parameter names to arguments
    const IR::IAnnotated *annotations;          // If non-null, the instance's annotations.

    /**
     * @return the extern instance that @expr resolves to, if any, or
     * std::nullopt otherwise.
     *
     * @expr may either refer to a named extern instance (i.e., it may be a
     * PathExpression), or it may construct an anonymous instance directly
     * (i.e., it may be a ConstructorCallExpression). In the latter case, the
     * instance will not have a name; @defaultName may optionally be used to
     * specify a default name to return.
     */
    static std::optional<ExternInstance> resolve(
        const IR::Expression *expr, ReferenceMap *refMap, TypeMap *typeMap,
        const std::optional<cstring> &defaultName = std::nullopt);

    /**
     * @return the extern instance that @path resolves to, if any, or
     * std::nullopt otherwise.
     */
    static std::optional<ExternInstance> resolve(const IR::PathExpression *path,
                                                 ReferenceMap *refMap, TypeMap *typeMap);

    /**
     * @return the extern instance that @constructorCallExpr resolves to, if any, or
     * std::nullopt otherwise.
     *
     * Anonymous instances do not have a name, but the caller may provide one
     * via @name if it has external information about what the name should be.
     */
    static std::optional<ExternInstance> resolve(
        const IR::ConstructorCallExpression *constructorCallExpr, ReferenceMap *refMap,
        TypeMap *typeMap, const std::optional<cstring> &name = std::nullopt);
};

}  // namespace P4

#endif /* FRONTENDS_P4_EXTERNINSTANCE_H_ */
