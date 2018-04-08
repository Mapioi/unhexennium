num gcd(int a, int b) {
  if (b == 0) {
    return a.abs();
  } else {
    return gcd(b, a % b);
  }
}

class Rational {
  int numerator, denominator;

  void canonicalize() {
    int d = gcd(numerator, denominator);
    numerator ~/= d;
    denominator ~/= d;
  }

  Rational(this.numerator, this.denominator) {
    assert(denominator != 0);
    canonicalize();
  }

  Rational.fromInt(int num) {
    numerator = num;
    denominator = 1;
  }

  @override
  String toString() => "$numerator / $denominator";

  Rational get opposite => new Rational(-numerator, denominator);

  Rational get reciprocal => new Rational(denominator, numerator);

  Rational operator +(Rational other) {
    return new Rational(
        this.numerator * other.denominator + other.numerator * this.denominator,
        this.denominator * other.denominator);
  }

  Rational operator *(Rational other) {
    return new Rational(
        this.numerator * other.numerator, this.denominator * other.denominator);
  }

  bool operator ==(dynamic other) {
    return other is Rational &&
        other.numerator / other.denominator == numerator / denominator;
  }

  @override
  int get hashCode => super.hashCode;
}
