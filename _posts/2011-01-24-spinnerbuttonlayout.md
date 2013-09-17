---
layout: post
title: JSpinnerのボタンを左右に配置する
category: swing
folder: SpinnerButtonLayout
tags: [JSpinner, ArrowButton, LayoutManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-01-24

## JSpinnerのボタンを左右に配置する
`JSpinner`のレイアウトを変更して、矢印ボタンを左右に配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TT0IT-0k7EI/AAAAAAAAAzA/8LBM7qgDVvw/s800/SpinnerButtonLayout.png)

### サンプルコード
<pre class="prettyprint"><code>class SpinnerLayout extends BorderLayout {
  @Override public void addLayoutComponent(Component comp, Object constraints) {
    String str = "";
    if("Editor".equals(constraints)) {
      str = "Center";
    } else if("Next".equals(constraints)) {
      str = "East";
    } else if("Previous".equals(constraints)) {
      str = "West";
    }
    super.addLayoutComponent(comp, str);
  }
}
</code></pre>

### 解説
- `Default`
    - デフォルト
- `RIGHT_TO_LEFT`
    - `JSpinner#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`で、ボタンを左側に配置
- `L(Prev), R(Next): 1`
    - `BorderLayout#addLayoutComponent(...)`をオーバーライドして、`Editor`を`Center`、`Next`を`East`、`Prev`を`West`に配置するレイアウトマネージャを作成して使用

<!-- dummy comment line for breaking list -->

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
    - `L(Prev), R(Next: 1`と同じレイアウトマネージャを`JSpinner#setLayout(...)`メソッドをオーバーライドして設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JSpinner spinner = new JSpinner(model) {
  @Override public void setLayout(LayoutManager mgr) {
    super.setLayout(new SpinnerLayout());
  }
};
</code></pre>

### コメント
