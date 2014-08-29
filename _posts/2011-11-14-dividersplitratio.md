---
layout: post
title: JSplitPaneのDividerの位置を最大化後に変更する
category: swing
folder: DividerSplitRatio
tags: [JSplitPane, JFrame]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-11-14

## JSplitPaneのDividerの位置を最大化後に変更する
`JFrame`を最大化した後で`JSplitPane`の`Divider`の位置を変更する場合のテストをします。

{% download https://lh3.googleusercontent.com/-w5-YQDwojUs/TsB7EdoVlLI/AAAAAAAABEw/p_PcxHKKeRk/s800/DividerSplitRatio.png %}

### サンプルコード
<pre class="prettyprint"><code>class SplitPaneWrapper extends JPanel {
  public SplitPaneWrapper(JSplitPane splitPane) {
    super(new BorderLayout());
    this.sp = splitPane;
    add(sp);
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        sp.setDividerLocation(0.5);
      }
    });
  }
  private static int getOrientedSize(JSplitPane sp) {
    return (sp.getOrientation() == JSplitPane.VERTICAL_SPLIT)
      ? sp.getHeight() - sp.getDividerSize()
      : sp.getWidth()  - sp.getDividerSize();
  }
  private int prev_state = Frame.NORMAL;
  @Override public void doLayout() {
    int size = getOrientedSize(sp);
    final double proportionalLocation = sp.getDividerLocation()/(double)size;
    super.doLayout();
    if(!flag) return;
    int state = ((Frame)SwingUtilities.getWindowAncestor(sp)).getExtendedState();
    if(sp.isShowing() &amp;&amp; state!=prev_state) {
      EventQueue.invokeLater(new Runnable() {
        @Override public void run() {
          int s = getOrientedSize(sp);
          int iv = (int)Math.round(s * proportionalLocation);
          sp.setDividerLocation(iv);
        }
      });
      prev_state = state;
    }
  }
}
</code></pre>

### 解説
- `JSplitPane#setResizeWeight(0.0)`なので、`JFrame`をマウスでリサイズしても上コンポーネントの高さが維持される
- `JSplitPane`をラップする`JPanel`の`doLayout()`メソッドをオーバーライドして、最大化、通常化の前後で上下コンポーネントの高さの比率を維持する
    - `EventQueue.invokeLater(...)`を使って、後で`JSplitPane#setDividerLocation(int)`でディバイダの位置を調節
    - デフォルト(`MAXIMIZED_BOTH: keep the same splitting ratio`チェックボックスのチェックを外している状態):
        - 例えば、最大化後にディバイダをすこし上に移動して`JFrame`を元に戻す(縮小)と、上コンポーネントの方が下コンポーネントより高くなる

<!-- dummy comment line for breaking list -->

- - - -
`JSplitPane#setDividerLocation(double)`は、内部で`JSplitPane#setDividerLocation(int)`を呼び出しているが、その変換の際に値を切り捨てているので、上記のサンプルでは最大化、元に戻す(縮小)を行なっても、同じ値になるように四捨五入するよう変更している。

### 参考リンク
- [JSplitPaneを等分割する](http://terai.xrea.jp/Swing/DividerLocation.html)

<!-- dummy comment line for breaking list -->

### コメント
