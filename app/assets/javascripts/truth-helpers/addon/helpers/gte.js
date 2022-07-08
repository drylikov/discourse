import Helper from "@ember/component/helper";

export function gte([left, right], hash) {
  if (hash.forceNumber) {
    if (typeof left !== "number") {
      left = Number(left);
    }
    if (typeof right !== "number") {
      right = Number(right);
    }
  }
  return left >= right;
}

export default Helper.helper(gte);
