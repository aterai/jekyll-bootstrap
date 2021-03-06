---
layout: post
category: swing
folder: SpinnerButtonLayout
title: JSpinnerのボタンを左右に配置する
tags: [JSpinner, ArrowButton, LayoutManager]
author: aterai
pubdate: 2011-01-24T14:15:43+09:00
description: JSpinnerのレイアウトを変更して、矢印ボタンを左右に配置します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TT0IT-0k7EI/AAAAAAAAAzA/8LBM7qgDVvw/s800/SpinnerButtonLayout.png
comments: true
---
## 概要
`JSpinner`のレイアウトを変更して、矢印ボタンを左右に配置します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TT0IT-0k7EI/AAAAAAAAAzA/8LBM7qgDVvw/s800/SpinnerButtonLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>class SpinnerLayout extends BorderLayout {
  @Override public void addLayoutComponent(Component comp, Object constraints) {
    Object cons = constraints;
    if ("Editor".equals(constraints)) {
      cons = "Center";
    } else if ("Next".equals(constraints)) {
      cons = "East";
    } else if ("Previous".equals(constraints)) {
      cons = "West";
    }
    super.addLayoutComponent(comp, cons);
  }
}
</code></pre>

## 解説
- `Default`
    - デフォルト
    - 右端に`2`つのボタンが配置される
- `RIGHT_TO_LEFT`
    - `JSpinner#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`で、各ボタンを左側に配置
- `L(Prev), R(Next): 1`
    - `BorderLayout#addLayoutComponent(...)`をオーバーライドして、`Editor`を`Center`、`Next`を`East`、`Prev`を`West`に配置するレイアウトマネージャーを作成して使用
        
        <pre class="prettyprint"><code>JSpinner spinner = new JSpinner(model) {
          @Override public void updateUI() {
            super.updateUI();
            setUI(new BasicSpinnerUI() {
              @Override protected LayoutManager createLayout() {
                return new SpinnerLayout();
              }
            });
          }
        };
</code></pre>
- `L(Prev), R(Next): 2`
    - `L(Prev), R(Next): 1`と同じレイアウトマネージャーを`JSpinner#setLayout(...)`メソッドをオーバーライドして設定
        
        <pre class="prettyprint"><code>JSpinner spinner = new JSpinner(model) {
          @Override public void setLayout(LayoutManager mgr) {
            super.setLayout(new SpinnerLayout());
          }
        };
</code></pre>
    - * 参考リンク [#reference]
- [BasicSpinnerUI#createLayout() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicSpinnerUI.html#createLayout--)

<!-- dummy comment line for breaking list -->

## コメント
