---
layout: post
category: swing
folder: SpinnerArrowButtonSize
title: JSpinnerのArrowButtonのサイズを変更
tags: [JSpinner, ArrowButton, LayoutManager, LookAndFeel, UIManager]
author: aterai
pubdate: 2018-07-02T15:35:14+09:00
description: JSpinnerのArrowButtonの幅と高さを変更します。
image: https://drive.google.com/uc?id=1McNGUqRAnh6645Jnm2JMAuKtzxtsD-B56w
comments: true
---
## 概要
`JSpinner`の`ArrowButton`の幅と高さを変更します。

{% download https://drive.google.com/uc?id=1McNGUqRAnh6645Jnm2JMAuKtzxtsD-B56w %}

## サンプルコード
<pre class="prettyprint"><code>JSpinner spinner4 = new JSpinner(model) {
  @Override public void updateUI() {
    super.updateUI();
    setFont(getFont().deriveFont(32f));
    stream(this)
      .filter(JButton.class::isInstance)
      .map(JButton.class::cast)
      .forEach(b -&gt; {
        Dimension d = b.getPreferredSize();
        d.width = 50;
        b.setPreferredSize(d);
      });
  }
};
</code></pre>

## 解説
- `default`
    - `JSpinner`の`BasicArrowButton`は、幅は`16px`固定、高さは`JSpinner`の高さの半分が推奨サイズになっている
- `Spinner.arrowButtonSize`
    - `UIManager.put("Spinner.arrowButtonSize", new Dimension(60, 0));`などで幅を指定可能(高さの指定は無視される)
    - 幅固定の`BasicArrowButton`を使用する`MetalLookAndFeel`や`MotifLookAndFeel`などでは無効
- `setPreferredSize`
    - `JSpinner`の子コンポーネントから`JButton`を検索して`JButton#setPreferredSize(...)`で幅を変更
    - 幅固定の`BasicArrowButton`を使用する`MetalLookAndFeel`や`MotifLookAndFeel`などでは無効
- `setLayout`
    - `LayoutManager#layoutContainer(...)`メソッドをオーバーライドして`ArrowButton`の幅を推奨サイズを無視して変更
    - `LookAndFeel`に関係なく幅を変更可能
- `setPreferredSize`での幅変更と合わせて、`JSpinner`のフォントサイズを変更して`ArrowButton`の高さも変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
    - `JButton`の検索に使用
- [JComboBoxのArrowButtonを隠す](https://ateraimemo.com/Swing/HideComboArrowButton.html)
    - `JSpinner`には、`JComboBox`の`UIManager.put("ComboBox.squareButton", Boolean.FALSE);`のような設定はない
- [JSpinnerのボタンを左右に配置する](https://ateraimemo.com/Swing/SpinnerButtonLayout.html)
    - `JSpinner`のレイアウト変更方法

<!-- dummy comment line for breaking list -->

## コメント
