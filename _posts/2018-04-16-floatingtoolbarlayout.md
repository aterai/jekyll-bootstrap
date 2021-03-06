---
layout: post
category: swing
folder: FloatingToolBarLayout
title: JToolBarがドラッグ・アウト状態になった場合、そのLayoutManagerを変更する
tags: [JToolBar, LayoutManager, BoxLayout, GridLayout]
author: aterai
pubdate: 2018-04-16T15:27:23+09:00
description: JToolBarがドラッグ・アウト状態になった場合、そのLayoutManagerをデフォルトのBoxLayoutからGridLayoutに変更します。
image: https://drive.google.com/uc?id=1C5Cd9XW5NYoQba530bfzr0nsstb407QGwA
comments: true
---
## 概要
`JToolBar`がドラッグ・アウト状態になった場合、その`LayoutManager`をデフォルトの`BoxLayout`から`GridLayout`に変更します。

{% download https://drive.google.com/uc?id=1C5Cd9XW5NYoQba530bfzr0nsstb407QGwA %}

## サンプルコード
<pre class="prettyprint"><code>JToolBar toolbar = new JToolBar(SwingConstants.VERTICAL);
// toolbar.setLayout(new BoxLayout(toolbar, BoxLayout.PAGE_AXIS));

// TEST:
// JToolBar toolbar = new JToolBar(orientation) {
//   @Override public Dimension getPreferredSize() {
//     if (((BasicToolBarUI) getUI()).isFloating()) {
//       setLayout(new GridLayout(0, 3));
//       return new Dimension(ICON_SIZE * 3, ICON_SIZE * 2);
//     } else {
//       setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
//       return super.getPreferredSize();
//     }
//   }
//
//   @Override public Dimension getMinimumSize() {
//     return getPreferredSize();
//   }
//
//   @Override public Dimension getMaximumSize() {
//     return getPreferredSize();
//   }
// };

JPanel panel = new JPanel() {
  @Override public Dimension getPreferredSize() {
    if (((BasicToolBarUI) toolbar.getUI()).isFloating()) {
      setLayout(new GridLayout(0, 3));
      return new Dimension(ICON_SIZE * 3, ICON_SIZE * 2);
    } else {
      setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
      return super.getPreferredSize();
    }
  }

  @Override public Dimension getMinimumSize() {
    return getPreferredSize();
  }

  @Override public Dimension getMaximumSize() {
    return getPreferredSize();
  }
};
panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
panel.add(new ColorPanel(Color.RED));
panel.add(new ColorPanel(Color.GREEN));
panel.add(new ColorPanel(Color.BLUE));
panel.add(new ColorPanel(Color.ORANGE));
panel.add(new ColorPanel(Color.CYAN));

toolbar.add(panel);
toolbar.add(Box.createGlue());
</code></pre>

## 解説
上記のサンプルでは、`JToolBar`が親の`JFrame`に格納されている場合は縦`BoxLayout`、ドラッグ・アウトされて`floating`状態の場合は`3`列`GridLayout`になるよう設定しています。

- このサンプルの`JToolBar`は親`JFrame`の左右にのみドッキング可能に制限
    - [JToolBarのドッキングを上下のみに制限](https://ateraimemo.com/Swing/DockingConstraint.html)
- `JToolBar`がドラッグ・アウトされているかどうかは、`BasicToolBarUI#isFloating()`メソッドで判断
- `getPreferredSize()`メソッドが実行されたときに、推奨サイズの変更と合わせて`LayoutManager`の切り替えを行う
    - `AncestorListener#ancestorAdded(...)`が実行されたときに`LayoutManager`の切り替えを行う方法もあるが、ドラッグ・アウト継続中に`JToolBar`の縦横が変化する場合に対応できない
    - `JToolBar#getPreferredSize()`をオーバーライドした場合、ドラッグ・アウトされた`JToolBar`のサイズが`JToolBar`の親`JDialog`まで拡大されてしまう
    - `JToolBar`の親`JDialog`のサイズは固定？で変更できないので、`JToolBar`の子に`JPanel`を挟んでこの`JPanel#getPreferredSize()`メソッドをオーバーライドし、`LayoutManager`を切り替えることで回避(ドラッグ・アウトされた`JToolBar`の左右に余白を設ける)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BasicToolBarUI#isFloating() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicToolBarUI.html#isFloating--)
- [JToolBarのドッキングを上下のみに制限](https://ateraimemo.com/Swing/DockingConstraint.html)

<!-- dummy comment line for breaking list -->

## コメント
