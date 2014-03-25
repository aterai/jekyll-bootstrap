---
layout: post
title: JSpinnerの上下限値をBigDecimalで比較する
category: swing
folder: BigDecimalSpinnerModel
tags: [JSpinner, BigDecimal, SpinnerNumberModel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-01-20

## JSpinnerの上下限値をBigDecimalで比較する
`JSpinner`で浮動小数点型のモデルを使用する場合、最大値と最小値の比較を`BigDecimal`で行うよう変更します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-JztoRl3kot0/UtvN48iHZ3I/AAAAAAAAB-g/D3QcAYgr_ks/s800/BigDecimalSpinnerModel.png)

### サンプルコード
<pre class="prettyprint"><code>class BigDecimalSpinnerModel extends SpinnerNumberModel {
  public BigDecimalSpinnerModel(double value, double minimum, double maximum, double stepSize) {
    super(value, minimum, maximum, stepSize);
  }
  @Override public Object getPreviousValue() {
    return incrValue(-1);
  }
  @Override public Object getNextValue() {
    return incrValue(+1);
  }
  private Number incrValue(int dir) {
    Number v = getNumber();
    BigDecimal value  = new BigDecimal(v.toString());
    BigDecimal stepSize = new BigDecimal(getStepSize().toString());
    BigDecimal maximum  = new BigDecimal(getMaximum().toString());
    BigDecimal minimum  = new BigDecimal(getMinimum().toString());
    BigDecimal newValue;

    if(dir&gt;0) {
      newValue = value.add(stepSize);
    }else{
      newValue = value.subtract(stepSize);
    }
    if(maximum != null &amp;&amp; maximum.compareTo(newValue) &lt; 0) {
      return null;
    }
    if(minimum != null &amp;&amp; minimum.compareTo(newValue) &gt; 0) {
      return null;
    }
    return newValue;
  }
}
</code></pre>

### 解説
- 上: `SpinnerNumberModel`
    - `Double`型の`SpinnerNumberModel`では、最大最小値の比較に、`Double#compare(...)`が使用されている
    - `stepSize`の`0.1`などが持つ浮動小数点の誤差のせいで、このサンプルの`JSpinner`の場合、下限(`2.0`や`29.6`)にダウンボタンで移動できない
        - 例えば、`29.7 - 29.6 - 0.1 >= 0`は偽
- 下: `BigDecimalSpinnerModel`
    - `SpinnerNumberModel#getPreviousValue()`などをオーバーライドして、`Double#compareTo(Double)`ではなく、`BigDecimal#compareTo(BigDecimal)`で最小値との比較を行う

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JavaFAQ: 浮動小数 float/double](http://homepage1.nifty.com/docs/java/faq/S029.html)
- [java - JSpinner not showing minimum value on pressing down arrow - Stack Overflow](http://stackoverflow.com/questions/21158043/jspinner-not-showing-minimum-value-on-pressing-down-arrow)
- [SpinnerNumberModelに上限値を超える値を入力](http://terai.xrea.jp/Swing/SpinnerNumberModel.html)

<!-- dummy comment line for breaking list -->

### コメント