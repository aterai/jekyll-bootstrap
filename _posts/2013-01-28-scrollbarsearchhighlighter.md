---
layout: post
title: JScrollBarに検索結果をハイライト表示
category: swing
folder: ScrollBarSearchHighlighter
tags: [JScrollBar, JScrollPane, JTextArea, JTextComponent, JViewport, Icon, Highlighter, Pattern, Matcher, MatteBorder]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-01-28

## JScrollBarに検索結果をハイライト表示
`JScrollBar`などに`JTextArea`の文字列検索の結果をハイライト表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-69jv_2q3f8g/UQT6FH3HXbI/AAAAAAAABcY/FmYcY3aLr6w/s800/ScrollBarSearchHighlighter.png)

### サンプルコード
<pre class="prettyprint"><code>scrollbar.setUI(new WindowsScrollBarUI() {
  @Override protected void paintTrack(
      Graphics g, JComponent c, Rectangle trackBounds) {
    super.paintTrack(g, c, trackBounds);

    Rectangle rect = textArea.getBounds();
    double sy = trackBounds.getHeight() / rect.getHeight();
    AffineTransform at = AffineTransform.getScaleInstance(1.0, sy);
    Highlighter highlighter = textArea.getHighlighter();
    g.setColor(Color.YELLOW);
    try{
      for(Highlighter.Highlight hh: highlighter.getHighlights()) {
        Rectangle r = textArea.modelToView(hh.getStartOffset());
        Rectangle s = at.createTransformedShape(r).getBounds();
        int h = 2; //Math.max(2, s.height-2);
        g.fillRect(trackBounds.x, trackBounds.y+s.y, trackBounds.width, h);
      }
    }catch(BadLocationException e) {
      e.printStackTrace();
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`ScrollBarUI#paintTrack(...)`メソッドをオーバーライドして、`JTextArea`内の文字列の検索結果を縦の`JScrollBar`内部に描画しています。

- 注:
    - 一行分のハイライトの高さは`2px`で固定
    - 検索結果の位置は`JTextComponent#modelToView(Matcher#start());`を利用しているため、ハイライト対象の文字列が折り返しで二行になっても、ハイライトされるのは開始位置のある一行目のみ

<!-- dummy comment line for breaking list -->

- - - -
以下のような`Icon`を設定した`JLabel`を`JScrollPane#setRowHeaderView(...)`で追加する方法もあります。こちらは、縦`JScrollBar`に直接ハイライトを描画しないので、上下の増減ボタンは考慮せず、またノブの代わりに現在表示位置を示す領域を半透明で描画しています。

<pre class="prettyprint"><code>JLabel label = new JLabel(new Icon() {
  private final Color THUMB_COLOR = new Color(0,0,255,50);
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Rectangle rect   = textArea.getBounds();
    Dimension sbSize = scrollbar.getSize();
    Insets sbInsets  = scrollbar.getInsets();
    double sy = (sbSize.height - sbInsets.top - sbInsets.bottom) / rect.getHeight();
    AffineTransform at = AffineTransform.getScaleInstance(1.0, sy);
    Highlighter highlighter = textArea.getHighlighter();

    g.setColor(Color.RED);
    try{
      for(Highlighter.Highlight hh: highlighter.getHighlights()) {
        Rectangle r = textArea.modelToView(hh.getStartOffset());
        Rectangle s = at.createTransformedShape(r).getBounds();
        int h = 2; //Math.max(2, s.height-2);
        g.fillRect(x, y+sbInsets.top+s.y, getIconWidth(), h);
      }
    }catch(BadLocationException e) {
      e.printStackTrace();
    }

    //paint Thumb
    JViewport vport = scroll.getViewport();
    Rectangle vrect = c.getBounds();
    vrect.y = vport.getViewPosition().y;
    g.setColor(THUMB_COLOR);
    Rectangle rr = at.createTransformedShape(vrect).getBounds();
    g.fillRect(x, y+sbInsets.top+rr.y, getIconWidth(), rr.height);
  }
  @Override public int getIconWidth() {
    return 4;
  }
  @Override public int getIconHeight() {
    return scrollbar.getHeight();
  }
});

scroll.setVerticalScrollBar(scrollbar);
/*
// Fixed Versions: 7 (b134)
scroll.setRowHeaderView(label);
/*/
// 6826074 JScrollPane does not revalidate the component hierarchy after scrolling
// http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6826074
// Affected Versions: 6u12,6u16,7
JViewport vp = new JViewport() {
  @Override public void setViewPosition(Point p) {
    super.setViewPosition(p);
    revalidate();
  }
};
vp.setView(label);
scroll.setRowHeader(vp);
</code></pre>

- - - -
縦`JScrollBar`の中ではなく、左横などにハイライト位置用の`Icon`を表示したい場合は、`MatteBorder`を利用する方法があります。

<pre class="prettyprint"><code>JScrollBar scrollBar = new JScrollBar(JScrollBar.VERTICAL) {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.width += getInsets().left;
    return d;
  }
  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createMatteBorder(0, 4, 0, 0, new Icon() {
      @Override public void paintIcon(Component c, Graphics g, int x, int y) {
        //...略...
      }
      @Override public int getIconWidth() {
        return getInsets().left;
      }
      @Override public int getIconHeight() {
        return getHeight();
      }
    }));
  }
};
scroll.setVerticalScrollBar(scrollBar);
</code></pre>

### コメント
- 行ヘッダーを使用したハイライトはJava7以降でのみ有効に機能するようです。 -- [読者](http://terai.xrea.jp/読者.html) 2013-08-18 (日) 23:10:11
    - ご指摘ありがとうございます。仰るとおり、`1.6.0_45`で行ヘッダ版が正常に動作しないことを確認しました。回避方法がないか、`Bug Database`あたりを調べてみようと思います。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-08-19 (月) 00:04:59
    - 修正された時期などから、[Bug ID: JDK-6910490 MatteBorder JScrollpane interaction](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6910490)が原因かもと`MatteBorder`は使用せずに直接`Icon`を`JLabel`に追加するよう変更したけど、改善しない…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-08-19 (月) 11:24:23
    - [Bug ID: JDK-6826074 JScrollPane does not revalidate the component hierarchy after scrolling](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6826074)が原因(`HeavyWeight`, `LightWeight`だけじゃなくレイアウトがうまく更新されていない？)のようです。`JViewport#setViewPosition(...)`をオーバーライドして`revalidate()`すれば、`1.7.0`と同様の動作をするようになりました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-08-19 (月) 14:43:11
- `Highlighter.Highlight#getStartOffset()`を使用するように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-08-23 (金) 16:14:35

<!-- dummy comment line for breaking list -->
