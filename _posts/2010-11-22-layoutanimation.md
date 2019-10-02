---
layout: post
category: swing
folder: LayoutAnimation
title: LayoutManagerを使ってパネルの展開アニメーションを行う
tags: [LayoutManager, Animation, BorderLayout, JTree, JPanel]
author: aterai
pubdate: 2010-11-22T14:41:14+09:00
description: パネルの展開・収納をアニメーションで行うLayoutManagerを作成します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTO_fTHG-I/AAAAAAAAAdQ/9SHzG18aVW0/s800/LayoutAnimation.png
comments: true
---
## 概要
パネルの展開・収納をアニメーションで行う`LayoutManager`を作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTO_fTHG-I/AAAAAAAAAdQ/9SHzG18aVW0/s800/LayoutAnimation.png %}

## サンプルコード
<pre class="prettyprint"><code>private Timer animator;
private boolean isHidden = true;
private final JPanel controls = new JPanel(new BorderLayout(5, 5) {
  private int controlsHeight;
  private int controlsPreferredHeight;
  @Override public Dimension preferredLayoutSize(Container target) {
    // synchronized (target.getTreeLock()) {
    Dimension ps = super.preferredLayoutSize(target);
    controlsPreferredHeight = ps.height;
    if (animator != null) {
      if (isHidden) {
        if (controls.getHeight() &lt; controlsPreferredHeight) {
          controlsHeight += 5;
        }
      } else {
        if (controls.getHeight() &gt; 0) {
          controlsHeight -= 5;
        }
      }
      if (controlsHeight &lt;= 0) {
        controlsHeight = 0;
        animator.stop();
      } else if (controlsHeight &gt;= controlsPreferredHeight) {
        controlsHeight = controlsPreferredHeight;
        animator.stop();
      }
    }
    ps.height = controlsHeight;
    return ps;
  }
});

private Action makeShowHideAction() {
  return new AbstractAction("Show/Hide Search Box") {
    @Override public void actionPerformed(ActionEvent e) {
      if (animator != null &amp;&amp; animator.isRunning()) {
        return;
      }
      isHidden = controls.getHeight() == 0;
      animator = new Timer(5, new ActionListener() {
        @Override public void actionPerformed(ActionEvent e) {
          controls.revalidate();
        }
      });
      animator.start();
    }
  };
}
</code></pre>

## 解説
上記のサンプルでは、`LayoutManager#preferredLayoutSize(...)`メソッドをオーバーライドして子パネルの高さを更新し展開アニメーションを表現しています。

- 内部の`JTree`の高さを縮小せずに重ねる状態で検索パネルを表示する場合は、`BorderLayout`ではなく`OverlayLayout`を[JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)のように使用する方法がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのノードを検索する](https://ateraimemo.com/Swing/SearchBox.html)
    - `JTree`のノードを検索するサンプル
- [JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

## コメント
