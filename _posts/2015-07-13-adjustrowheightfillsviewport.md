---
layout: post
category: swing
folder: AdjustRowHeightFillsViewport
title: JTableの行高がJViewportの高さに合うまで調整する
tags: [JTable, JViewport, JScrollPane]
author: aterai
pubdate: 2015-07-13T02:32:20+09:00
description: JTableの各行の高さ変更することで行数などに変更があっても、JViewportに余白が発生しないように調整します。
image: https://lh3.googleusercontent.com/-Poa86QgNChU/VaKgwOMpRdI/AAAAAAAAN9E/2gQi6newmek/s800-Ic42/AdjustRowHeightFillsViewport.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/09/adjust-height-of-every-row-in-jtable-to.html
    lang: en
comments: true
---
## 概要
`JTable`の各行の高さ変更することで行数などに変更があっても、`JViewport`に余白が発生しないように調整します。

{% download https://lh3.googleusercontent.com/-Poa86QgNChU/VaKgwOMpRdI/AAAAAAAAN9E/2gQi6newmek/s800-Ic42/AdjustRowHeightFillsViewport.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  int prevHeight = -1;
  int prevCount = -1;

  private void updateRowsHeight(JViewport vport) {
    int height = vport.getExtentSize().height;
    int rowCount = getModel().getRowCount();
    int defaultRowHeight = height / rowCount;
    if ((height != prevHeight || rowCount != prevCount) &amp;&amp; defaultRowHeight &gt; 0) {
      // int remainder = height - rowCount * defaultRowHeight;
      int remainder = height % rowCount;
      for (int i = 0; i &lt; rowCount; i++) {
        int a = remainder &gt; 0 ? i == rowCount - 1 ? remainder : 1 : 0;
        setRowHeight(i, defaultRowHeight + a);
        remainder--;
      }
    }
    prevHeight = height;
    prevCount = rowCount;
  }

  @Override public void doLayout() {
    super.doLayout();
    Container p = SwingUtilities.getAncestorOfClass(JViewport.class, this);
    if (p instanceof JViewport) {
      updateRowsHeight((JViewport) p);
    }
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JViewport`のサイズまで`JTable`の各セルを`GridLayout`風に同比率で拡大縮小するよう`JTable#doLayout()`メソッドをオーバーライドしています。

- 余白(高さ方向)の調整
    - `JViewport`の高さが変更されたり行数の増減が発生した場合、各行の高さを`JTable#setRowHeight(...)`で設定し直すことで、`JViewport`に余白が生成されないように調整

<!-- dummy comment line for breaking list -->

- - - -
- `JScrollPane`の高さだけ変更した場合、`JTable#doLayout()`が呼び出されなくなった？
    - `JTable#setFillsViewportHeight(true)`を設定しても高さの拡大縮小で`JTable#doLayout()`が呼び出されない
    - `JScrollPane`に`ComponentListener`を追加して回避
        
        <pre class="prettyprint"><code>scroll.addComponentListener(new ComponentAdapter() {
          @Override public void componentResized(ComponentEvent e) {
            Component c = e.getComponent();
            if (c instanceof JScrollPane) {
              ((JScrollPane) c).getViewport().getView().revalidate();
            }
          }
        });
</code></pre>
    - * 参考リンク [#reference]
- [JTableの行の高さを変更する](https://ateraimemo.com/Swing/FishEyeTable.html)
- [JTable#setRowHeight(int, int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setRowHeight-int-int-)

<!-- dummy comment line for breaking list -->

## コメント
- このページへのリンクがサイト全体で間違えていたのを修正。 -- *aterai* 2015-07-27 (水) 17:57:58

<!-- dummy comment line for breaking list -->
