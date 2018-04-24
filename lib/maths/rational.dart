import 'package:unhexennium/utils.dart';

int gcd(int a, int b) {
  if (b == 0) {
    return a.abs();
  } else {
    return gcd(b, a % b);
  }
}

int gcdMultiple(Iterable<int> numbers) {
  return numbers.reduce((value, number) => gcd(value, number));
}

int lcm(int a, int b) {
  return a * b ~/ gcd(a, b);
}

int lcmMultiple(Iterable<int> numbers) {
  return numbers.reduce((value, number) => lcm(value, number));
}

class Rational {
  int numerator, denominator;

  void canonicalize() {
    int d = gcd(numerator, denominator);
    numerator ~/= d;
    denominator ~/= d;
    if (denominator < 0) {
      numerator ~/= -1;
      denominator ~/= -1;
    }
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
  String toString() {
    if (denominator != 1) {
      return asSuperscript(numerator.toString()) +
          "/" +
          asSubscript(denominator.toString());
    } else {
      return numerator.toString();
    }
  }

  Rational get opposite => new Rational(-numerator, denominator);

  Rational get reciprocal => new Rational(denominator, numerator);

  Rational get abs => new Rational(numerator.abs(), denominator);

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
