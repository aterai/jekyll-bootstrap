---
layout: post
category: swing
folder: OverlappedScrollBar
title: JScrollBarをJTable上に重ねて表示するJScrollPaneを作成する
tags: [JScrollPane, JScrollBar, JTable, LayoutManager]
author: aterai
pubdate: 2015-11-30T00:46:26+09:00
description: 半透明のJScrollBarをJTable上に重ねてレイアウトするJScrollPaneを作成します。
image: https://lh3.googleusercontent.com/-IHqUJwyfm8A/Vlsa4OUr4XI/AAAAAAAAOHk/QWKZO4xmtQo/s800-Ic42/OverlappedScrollBar.png
comments: true
---
## 概要
半透明の`JScrollBar`を`JTable`上に重ねてレイアウトする`JScrollPane`を作成します。

{% download https://lh3.googleusercontent.com/-IHqUJwyfm8A/Vlsa4OUr4XI/AAAAAAAAOHk/QWKZO4xmtQo/s800-Ic42/OverlappedScrollBar.png %}

## サンプルコード
<pre class="prettyprint"><code>class OverlapScrollPaneLayout extends ScrollPaneLayout {
  private static final int BAR_SIZE = 12;
  @Override public void layoutContainer(Container parent) {
    if (parent instanceof JScrollPane) {
      JScrollPane scrollPane = (JScrollPane) parent;

      Rectangle availR = scrollPane.getBounds();
      availR.setLocation(0, 0); // availR.x = availR.y = 0;

      Insets insets = parent.getInsets();
      availR.x = insets.left;
      availR.y = insets.top;
      availR.width -= insets.left + insets.right;
      availR.height -= insets.top  + insets.bottom;

      Rectangle colHeadR = new Rectangle(0, availR.y, 0, 0);
      if (colHead != null &amp;&amp; colHead.isVisible()) {
        int colHeadHeight = Math.min(
            availR.height, colHead.getPreferredSize().height);
        colHeadR.height = colHeadHeight;
        availR.y += colHeadHeight;
        availR.height -= colHeadHeight;
      }

      colHeadR.width = availR.width;
      colHeadR.x = availR.x;
      if (colHead != null) {
        colHead.setBounds(colHeadR);
      }

      Rectangle hsbR = new Rectangle();
      hsbR.height = BAR_SIZE;
      hsbR.width = availR.width - hsbR.height;
      hsbR.x = availR.x;
      hsbR.y = availR.y + availR.height - hsbR.height;

      Rectangle vsbR = new Rectangle();
      vsbR.width = BAR_SIZE;
      vsbR.height = availR.height - vsbR.width;
      vsbR.x = availR.x + availR.width - vsbR.width;
      vsbR.y = availR.y;

      if (viewport != null) {
        viewport.setBounds(availR);
      }
      if (vsb != null) {
        vsb.setVisible(true);
        vsb.setBounds(vsbR);
      }
      if (hsb != null) {
        hsb.setVisible(true);
        hsb.setBounds(hsbR);
      }
    }
  }
}
</code></pre>

## 解説
- [JScrollBarを半透明にする](https://ateraimemo.com/Swing/TranslucentScrollBar.html)とほぼ同様の`ScrollPaneLayout`を使用
    - ただし`JTable`のヘッダを表示するために`JScrollPane`のカラムヘッダのレイアウトに対応するよう追加修正
- 水平スクロールバーにも対応しているが、右下のコーナーコンポーネントは常に空き状態になる
    - 片方のスクロールバーが非表示でもその領域まで拡張しない
- スクロールバーの幅は推奨サイズなどを無視して固定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollBarを半透明にする](https://ateraimemo.com/Swing/TranslucentScrollBar.html)

<!-- dummy comment line for breaking list -->

## コメント
