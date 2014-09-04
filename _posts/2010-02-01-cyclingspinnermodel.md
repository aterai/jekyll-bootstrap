---
layout: post
title: JSpinnerのモデルの値をループさせる
category: swing
folder: CyclingSpinnerModel
tags: [JSpinner, SpinnerNumberModel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-02-01

## 概要
`JSpinner`のモデルで値が最大、最小を超えるとループするように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKYcCKxAI/AAAAAAAAAV4/T8OdovAF6EY/s800/CyclingSpinnerModel.png %}

## サンプルコード
<pre class="prettyprint"><code>spinner.setModel(new SpinnerNumberModel(20, 0, 59, 1) {
  @Override public Object getNextValue() {
    Object n = super.getNextValue();
    if(n==null) n = getMinimum();
    return n;
  }
  @Override public Object getPreviousValue() {
    Object n = super.getPreviousValue();
    if(n==null) n = getMaximum();
    return n;
  }
});
</code></pre>

## 解説
上記のサンプルでは、各モデルの`getNextValue`、`getPreviousValue`メソッドをオーバーライドすることでループするように設定しています。

## 参考リンク
- [Creating Custom Spinner Models and Editors](http://docs.oracle.com/javase/tutorial/uiswing/components/spinner.html#model)

<!-- dummy comment line for breaking list -->

## コメント
