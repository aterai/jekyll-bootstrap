---
layout: post
category: swing
folder: DividerSplitRatio
title: JSplitPaneのDividerの位置を最大化後に変更する
tags: [JSplitPane, JFrame, Divider]
author: aterai
pubdate: 2011-11-14T11:39:46+09:00
description: JFrameを最大化した後でJSplitPaneのDividerの位置を変更する場合のテストをします。
image: https://lh3.googleusercontent.com/-w5-YQDwojUs/TsB7EdoVlLI/AAAAAAAABEw/p_PcxHKKeRk/s800/DividerSplitRatio.png
comments: true
---
## 概要
`JFrame`を最大化した後で`JSplitPane`の`Divider`の位置を変更する場合のテストをします。

{% download https://lh3.googleusercontent.com/-w5-YQDwojUs/TsB7EdoVlLI/AAAAAAAABEw/p_PcxHKKeRk/s800/DividerSplitRatio.png %}

## サンプルコード
<pre class="prettyprint"><code>class SplitPaneWrapper extends JPanel {
  private int prevState = Frame.NORMAL;
  private final JSplitPane splitPane;

  protected SplitPaneWrapper(JSplitPane splitPane) {
    super(new BorderLayout());
    this.splitPane = splitPane;
    add(splitPane);
    EventQueue.invokeLater(() -&gt; splitPane.setDividerLocation(.5));
  }
  private static int getOrientedSize(JSplitPane sp) {
    return (sp.getOrientation() == JSplitPane.VERTICAL_SPLIT)
           ? sp.getHeight() - sp.getDividerSize()
           : sp.getWidth()  - sp.getDividerSize();
  }
  @Override public void doLayout() {
    int size = getOrientedSize(splitPane);
    final double proportionalLocation = splitPane.getDividerLocation() / (double) size;
    super.doLayout();
    int state = ((Frame) SwingUtilities.getWindowAncestor(splitPane)).getExtendedState();
    if (splitPane.isShowing() &amp;&amp; state != prevState) {
      EventQueue.invokeLater(() -&gt; {
        int s = getOrientedSize(splitPane);
        int iv = (int) Math.round(s * proportionalLocation);
        System.out.format("DividerLocation: %d%n", iv);
        splitPane.setDividerLocation(iv);
      });
      prevState = state;
    }
  }
}
</code></pre>

## 解説
- `MAXIMIZED_BOTH: keep the same splitting ratio`が未選択の場合:
    - `JSplitPane#setResizeWeight(0d)`に設定されているので、`JFrame`をマウスでリサイズしても上コンポーネントの高さが維持される
- `MAXIMIZED_BOTH: keep the same splitting ratio`が選択されている場合:
    - `JSplitPane`をラップする`JPanel`の`doLayout()`メソッドをオーバーライドして、最大化、通常化の前後で上下コンポーネントの高さの比率を維持する
    - `EventQueue.invokeLater(...)`を使って、後で`JSplitPane#setDividerLocation(int)`でディバイダの位置を調節
    - デフォルト(`MAXIMIZED_BOTH: keep the same splitting ratio`チェックボックスのチェックを外している状態):
        - 例えば、最大化後にディバイダをすこし上に移動して`JFrame`を元に戻す(縮小)と、上コンポーネントの方が下コンポーネントより高くなる
    - `JSplitPane#setDividerLocation(double)`は、内部で`JSplitPane#setDividerLocation(int)`を呼び出しているが、その変換の際に値を切り捨てているので、このサンプルでは最大化、元に戻す(縮小)を行なっても、同じ値になるように四捨五入するよう変更している

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSplitPaneを等分割する](https://ateraimemo.com/Swing/DividerLocation.html)

<!-- dummy comment line for breaking list -->

## コメント
