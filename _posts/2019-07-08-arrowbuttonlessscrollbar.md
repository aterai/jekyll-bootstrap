---
layout: post
category: swing
folder: ArrowButtonlessScrollBar
title: JScrollBarのArrowButtonを非表示にする
tags: [JScrollBar, ArrowButton, JScrollPane]
author: aterai
pubdate: 2019-07-08T16:03:23+09:00
description: JScrollBarのArrowButtonを非表示に設定します。
image: https://drive.google.com/open?id=1Z86M0kl6w-3P0yhRIA5uyxj8PEtvbJPr
comments: true
---
## 概要
`JScrollBar`の`ArrowButton`を非表示に設定します。

{% download https://drive.google.com/uc?id=1Z86M0kl6w-3P0yhRIA5uyxj8PEtvbJPr %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ScrollBar.width", 10);
UIManager.put("ScrollBar.thumbHeight", 20); // GTK, SynthLookAndFeel
UIManager.put("ScrollBar.minimumThumbSize", new Dimension(30, 30));
UIManager.put("ScrollBar.incrementButtonGap", 0);
UIManager.put("ScrollBar.decrementButtonGap", 0);

JScrollPane scroll = new JScrollPane(new JTextArea(txt)) {
  @Override public void updateUI() {
    super.updateUI();
    getVerticalScrollBar().setUI(new ArrowButtonlessScrollBarUI());
    getHorizontalScrollBar().setUI(new ArrowButtonlessScrollBarUI());
  }
};
// ...

class ZeroSizeButton extends JButton {
  private static final Dimension ZERO_SIZE = new Dimension();

  @Override public Dimension getPreferredSize() {
    return ZERO_SIZE;
  }
}

class ArrowButtonlessScrollBarUI extends BasicScrollBarUI {
  @Override protected JButton createDecreaseButton(int orientation) {
    return new ZeroSizeButton();
  }

  @Override protected JButton createIncreaseButton(int orientation) {
    return new ZeroSizeButton();
  }

  // @Override protected Dimension getMinimumThumbSize() {
  //   // return new Dimension(20, 20);
  //   return UIManager.getDimension("ScrollBar.minimumThumbSize");
  // }

  // ...
}
</code></pre>

## 解説
- 左: `ArrowButton`有り(デフォルト)
    - `UIManager.put("ScrollBar.width", 10);`で`JScrollBar`の幅を変更
    - `ArrowButton`のアイコンサイズは変更されず？、微妙にずれてしまう
    - `UIManager.put("ScrollBar.thumbHeight", 20);`は、`GTKLookAndFeel`、`SynthLookAndFeel`(`NimbusLookAndFeel`)でのみ有効？
        - `UIManager.put("ArrowButton.size", 8);`などを設定しても変化しない？
- 右: `ArrowButton`無し
    - `BasicScrollBarUI#createDecreaseButton(...)`、`BasicScrollBarUI#createIncreaseButton(...)`メソッドをオーバーライドしてサイズ`0`の`JButton`を適用
    - `JButton#setVisible(false);`の場合、`ArrowButton`は非表示になるが`JScrollBar`に余白が残る
    - `UIManager.put("ScrollBar.squareButtons", Boolean.TRUE);`を設定すると`ArrowButton#getPreferredSize()`が無視されて`JScrollBar`の幅で`ArrowButton`は正方形になる(非表示ではなくなる)
    - 以下のように`new JScrollBar(Adjustable.VERTICAL)`で`JScrollBar`を作成するとトラックをクリックした場合のスクロール速度がデフォルトより遅くなる？
        
        <pre class="prettyprint"><code>JScrollPane scrollPane = new JScrollPane(new JTextArea(txt));
        scrollPane.setVerticalScrollBar(new JScrollBar(Adjustable.VERTICAL) {
          @Override public void updateUI() {
            super.updateUI();
            setUI(new ArrowButtonlessScrollBarUI());
            // ホイールでのスクロール速度は以下で速くなる
            putClientProperty("JScrollBar.fastWheelScrolling", Boolean.TRUE);
          }
        });
</code></pre>
    - * 参考リンク [#reference]
- [JScrollBarを半透明にする](https://ateraimemo.com/Swing/TranslucentScrollBar.html)

<!-- dummy comment line for breaking list -->

## コメント
