import 'dart:math';

class Vector2D {
  final double x;
  final double y;

  Vector2D(this.x, this.y);

  Vector2D operator -(Vector2D other) {
    return Vector2D(x - other.x, y - other.y);
  }

  double get magnitude {
    return sqrt(x * x + y * y);
  }

  double dot(Vector2D other) {
    return x * other.x + y * other.y;
  }

  double angleBetween(Vector2D other) {
    final cosTheta = dot(other) / (magnitude * other.magnitude);
    // Ensure value is within valid range for acos
    final clampedCos = cosTheta.clamp(-1.0, 1.0);
    return acos(clampedCos);
  }
}

class Vector3D {
  final double x;
  final double y;
  final double z;

  Vector3D(this.x, this.y, this.z);

  Vector3D operator -(Vector3D other) {
    return Vector3D(x - other.x, y - other.y, z - other.z);
  }

  double get magnitude {
    return sqrt(x * x + y * y + z * z);
  }

  double dot(Vector3D other) {
    return x * other.x + y * other.y + z * other.z;
  }

  double angleBetween(Vector3D other) {
    final cosTheta = dot(other) / (magnitude * other.magnitude);
    // Ensure value is within valid range for acos
    final clampedCos = cosTheta.clamp(-1.0, 1.0);
    return acos(clampedCos);
  }
}
