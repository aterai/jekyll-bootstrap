---
layout: post
category: swing
folder: ThreeColumnLayout
title: Componentの3列配置、中央幅固定、左右均等引き伸ばしを行うLayoutManagerを作成する
tags: [LayoutManager, BorderLayout, SpringLayout]
author: aterai
pubdate: 2018-04-30T18:00:57+09:00
description: Componentを3列配置し、中央は常に幅固定、左右は均等に水平引き伸ばしを行うLayoutManagerを作成します。
image: https://drive.google.com/uc?id=1fYOmz2pJNyjhyvSGvLkvh-G1PQtL3_U2Kg
comments: true
---
## 概要
`Component`を`3`列配置し、中央は常に幅固定、左右は均等に水平引き伸ばしを行う`LayoutManager`を作成します。

{% download https://drive.google.com/uc?id=1fYOmz2pJNyjhyvSGvLkvh-G1PQtL3_U2Kg %}

## サンプルコード
<pre class="prettyprint"><code>// SpringLayout
SpringLayout layout = new SpringLayout();
JPanel panel = new JPanel(layout);
panel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));

SpringLayout.Constraints centerConstraints = layout.getConstraints(box);
centerConstraints.setWidth(Spring.constant(box.getPreferredSize().width));

SpringLayout.Constraints leftConstraints = layout.getConstraints(lsp);
SpringLayout.Constraints rightConstraints = layout.getConstraints(rsp);

Spring width = Spring.max(
    leftConstraints.getWidth(), rightConstraints.getWidth());
leftConstraints.setWidth(width);
rightConstraints.setWidth(width);

panel.add(lsp, leftConstraints);
panel.add(box, centerConstraints);
panel.add(rsp, rightConstraints);

Spring height = layout.getConstraint(SpringLayout.HEIGHT, panel);
leftConstraints.setHeight(height);
rightConstraints.setHeight(height);
centerConstraints.setHeight(height);

centerConstraints.setConstraint(
    SpringLayout.WEST, leftConstraints.getConstraint(SpringLayout.EAST));
rightConstraints.setConstraint(
    SpringLayout.WEST, centerConstraints.getConstraint(SpringLayout.EAST));

layout.putConstraint(SpringLayout.EAST, panel, 0, SpringLayout.EAST, rsp);

// override BorderLayout#layoutContainer(...)
JPanel panel = new JPanel(new BorderLayout(0, 0) {
  @Override public void layoutContainer(Container target) {
    synchronized (target.getTreeLock()) {
      Insets insets = target.getInsets();
      int top = insets.top;
      int bottom = target.getHeight() - insets.bottom;
      int left = insets.left;
      int right = target.getWidth() - insets.right;
      int hgap = getHgap();
      int wc = right - left;
      int we = wc / 2;
      int ww = wc - we;
      Component c = getLayoutComponent(CENTER);
      if (c != null) {
        Dimension d = c.getPreferredSize();
        wc -= d.width + hgap + hgap;
        we = wc / 2;
        ww = wc - we;
        c.setBounds(left + hgap + ww, top, wc, bottom - top);
      }
      c = getLayoutComponent(EAST);
      if (c != null) {
        c.setBounds(right - we, top, we, bottom - top);
      }
      c = getLayoutComponent(WEST);
      if (c != null) {
        c.setBounds(left, top, ww, bottom - top);
      }
    }
  }
});
panel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
panel.add(lsp, BorderLayout.WEST);
panel.add(box, BorderLayout.CENTER);
panel.add(rsp, BorderLayout.EAST);
</code></pre>

## 解説
- `SpringLayout`
    - 中央の`JButton`の入った`Box`は、以下のように常に推奨サイズの固定サイズになるような制約を設定
        
        <pre class="prettyprint"><code>SpringLayout.Constraints centerConstraints = layout.getConstraints(box);
        centerConstraints.setWidth(Spring.constant(box.getPreferredSize().width));
</code></pre>
    - 左右の`JList`(`JScrollPane`)は、以下のように大きい方の制約の幅で同サイズになるよう設定
        
        <pre class="prettyprint"><code>Spring width = Spring.max(leftConstraints.getWidth(), rightConstraints.getWidth());
        leftConstraints.setWidth(width);
        rightConstraints.setWidth(width);
</code></pre>
    - `3`列配置するコンポーネントの高さは、以下のように親`JPanel`と同じ高さになるよう設定
        
        <pre class="prettyprint"><code>Spring height = layout.getConstraint(SpringLayout.HEIGHT, panel);
        leftConstraints.setHeight(height);
        rightConstraints.setHeight(height);
        centerConstraints.setHeight(height);
</code></pre>
    - [JListからの大量アイテム削除を高速化する](https://ateraimemo.com/Swing/FastRemoveOfListItems.html)も`SpringLayout`を使用しているが、`3`列の幅をすべてパーセントで指定しており中央の幅は固定ではない
    - 参考: [Java Swing: How to make JLists resize properly when GridBagLayout column is set to grow, ignoring the JList's item widths? - Stack Overflow](https://stackoverflow.com/questions/49978526/java-swing-how-to-make-jlists-resize-properly-when-gridbaglayout-column-is-set/50009817#50009817)のVGRさんの回答が`SpringLayout`を使用して同様のレイアウトを実現している
        - 中央幅の固定と高さの設定方法が少し異なる
- `BorderLayout`
    - `BorderLayout#layoutContainer(...)`をオーバーライドして、親コンポーネントの幅が変更されたら中央は常に幅固定、左右は均等に水平引き伸ばしを行う
    - デフォルトの`BorderLayout`は`3`列レイアウトの場合、左右は常に推奨サイズの幅で固定、中央は水平・垂直両方向に引き伸ばし
    - 上下配置や`ComponentOrientation`などは考慮していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JListからの大量アイテム削除を高速化する](https://ateraimemo.com/Swing/FastRemoveOfListItems.html)
- [Java Swing: How to make JLists resize properly when GridBagLayout column is set to grow, ignoring the JList's item widths? - Stack Overflow](https://stackoverflow.com/questions/49978526/java-swing-how-to-make-jlists-resize-properly-when-gridbaglayout-column-is-set/50009817#50009817)

<!-- dummy comment line for breaking list -->

## コメント
