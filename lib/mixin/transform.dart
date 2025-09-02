mixin TransformMixin {
  num toNumber(String? value) {
    // 1. 检查空值
    if (value == null || value.trim().isEmpty) {
      return 0;
    }

    // 2. 检查是否全为数字（允许小数点和负号）
    final isNumeric = RegExp(r'^-?\d*\.?\d+$').hasMatch(value);
    if (!isNumeric) {
      return 0;
    }

    // 3. 安全转换为数字
    return num.tryParse(value) ?? 0;
  }

  bool toBool(String? value) {
    // 1. 检查空值
    if (value == null || value.trim().isEmpty) {
      return true;
    }
    return false;
  }
}