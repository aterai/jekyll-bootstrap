---
layout: post
category: swing
folder: ScrollBarSearchHighlighter
title: JScrollBarに検索結果をハイライト表示
tags: [JScrollBar, JScrollPane, JTextArea, JTextComponent, JViewport, Icon, Highlighter, Pattern, Matcher, MatteBorder]
author: aterai
pubdate: 2013-01-28T02:11:33+09:00
description: JScrollBarなどにJTextAreaの文字列検索の結果をハイライト表示します。
image: https://lh4.googleusercontent.com/-69jv_2q3f8g/UQT6FH3HXbI/AAAAAAAABcY/FmYcY3aLr6w/s800/ScrollBarSearchHighlighter.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/01/jscrollbar-search-highlighter.html
    lang: en
comments: true
---
## 概要
`JScrollBar`などに`JTextArea`の文字列検索の結果をハイライト表示します。

{% download https://lh4.googleusercontent.com/-69jv_2q3f8g/UQT6FH3HXbI/AAAAAAAABcY/FmYcY3aLr6w/s800/ScrollBarSearchHighlighter.png %}

## サンプルコード
<pre class="prettyprint"><code>scrollbar.setUI(new WindowsScrollBarUI() {
  @Override protected void paintTrack(
      Graphics g, JComponent c, Rectangle trackBounds) {
    super.paintTrack(g, c, trackBounds);

    Rectangle rect = textArea.getBounds();
    double sy = trackBounds.getHeight() / rect.getHeight();
    AffineTransform at = AffineTransform.getScaleInstance(1d, sy);
    Highlighter highlighter = textArea.getHighlighter();
    g.setColor(Color.YELLOW);
    try {
      for (Highlighter.Highlight hh: highlighter.getHighlights()) {
        Rectangle r = textArea.modelToView(hh.getStartOffset());
        Rectangle s = at.createTransformedShape(r).getBounds();
        int h = 2; //Math.max(2, s.height - 2);
        g.fillRect(trackBounds.x, trackBounds.y + s.y, trackBounds.width, h);
      }
    } catch (BadLocationException e) {
      e.printStackTrace();
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`ScrollBarUI#paintTrack(...)`メソッドをオーバーライドして、`JTextArea`内の文字列の検索結果を縦の`JScrollBar`内部に描画しています。

- `1`行分のハイライトの高さは`2px`で固定
- 検索結果の位置は`JTextComponent#modelToView(Matcher#start());`を利用しているため、ハイライト対象の文字列が折り返しで`2`行になってもハイライトされるのは開始位置のある`1`行目のみ

<!-- dummy comment line for breaking list -->

- - - -
以下のような`Icon`を設定した`JLabel`を`JScrollPane#setRowHeaderView(...)`で追加する方法もあります。こちらは縦`JScrollBar`に直接ハイライトを描画しないので上下の増減ボタンサイズは考慮せず、またノブの代わりに現在表示位置を示す領域を半透明で描画しています。

<pre class="prettyprint"><code>JLabel label = new JLabel(new Icon() {
  private final Color THUMB_COLOR = new Color(0, 0, 255, 50);
  private final Rectangle thumbRect = new Rectangle();
  private final JTextComponent textArea;
  private final JScrollBar scrollbar;
  public HighlightIcon(JTextComponent textArea, JScrollBar scrollbar) {
    this.textArea  = textArea;
    this.scrollbar = scrollbar;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    // Rectangle rect   = textArea.getBounds();
    // Dimension sbSize = scrollbar.getSize();
    // Insets sbInsets  = scrollbar.getInsets();
    // double sy = (sbSize.height - sbInsets.top - sbInsets.bottom) / rect.getHeight();
    int itop = scrollbar.getInsets().top;
    BoundedRangeModel range = scrollbar.getModel();
    double sy = range.getExtent() / (double) (range.getMaximum() - range.getMinimum());
    AffineTransform at = AffineTransform.getScaleInstance(1.0, sy);
    Highlighter highlighter = textArea.getHighlighter();

    // paint Highlight
    g.setColor(Color.RED);
    try {
      for (Highlighter.Highlight hh: highlighter.getHighlights()) {
        Rectangle r = textArea.modelToView(hh.getStartOffset());
        Rectangle s = at.createTransformedShape(r).getBounds();
        int h = 2; // Math.max(2, s.height - 2);
        g.fillRect(x, y + itop + s.y, getIconWidth(), h);
      }
    } catch (BadLocationException e) {
      e.printStackTrace();
    }

    // paint Thumb
    if (scrollbar.isVisible()) {
      // JViewport vport = Objects.requireNonNull(
      //   (JViewport) SwingUtilities.getAncestorOfClass(JViewport.class, textArea));
      // Rectangle thumbRect = vport.getBounds();
      thumbRect.height = range.getExtent();
      thumbRect.y = range.getValue(); // vport.getViewPosition().y;
      g.setColor(THUMB_COLOR);
      Rectangle s = at.createTransformedShape(thumbRect).getBounds();
      g.fillRect(x, y + itop + s.y, getIconWidth(), s.height);
    }
  }

  @Override public int getIconWidth() {
    return 8;
  }

  @Override public int getIconHeight() {
    JViewport vport = Objects.requireNonNull(
      (JViewport) SwingUtilities.getAncestorOfClass(JViewport.class, textArea));
    return vport.getHeight();
  }
});

scroll.setVerticalScrollBar(scrollbar);
/*
// Fixed Versions: 7 (b134)
scroll.setRowHeaderView(label);
/*/
// 6826074 JScrollPane does not revalidate the component hierarchy after scrolling
// https://bugs.openjdk.java.net/browse/JDK-6826074
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

<pre class="prettyprint"><code>JScrollBar scrollBar = new JScrollBar(Adjustable.VERTICAL) {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.width += getInsets().left;
    return d;
  }

  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createMatteBorder(0, 4, 0, 0, new Icon() {
      @Override public void paintIcon(Component c, Graphics g, int x, int y) {
        // ...略...
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

## 参考リンク
- [JLabelとIconで作成した検索位置表示バーをマウスで操作する](https://ateraimemo.com/Swing/ScrollBarSearchHighlighter.html)

<!-- dummy comment line for breaking list -->

## コメント
- 行ヘッダーを使用したハイライトは`Java7`以降でのみ有効に機能するようです。 -- *読者* 2013-08-18 (日) 23:10:11
    - ご指摘ありがとうございます。仰るとおり、`1.6.0_45`で行ヘッダ版が正常に動作しないことを確認しました。回避方法がないか、`Bug Database`あたりを調べてみようと思います。 -- *aterai* 2013-08-19 (月) 00:04:59
    - 修正された時期などから、[Bug ID: JDK-6910490 MatteBorder JScrollpane interaction](https://bugs.openjdk.java.net/browse/JDK-6910490)が原因かもと`MatteBorder`は使用せずに直接`Icon`を`JLabel`に追加するよう変更したけど、改善しない…。 -- *aterai* 2013-08-19 (月) 11:24:23
    - [Bug ID: JDK-6826074 JScrollPane does not revalidate the component hierarchy after scrolling](https://bugs.openjdk.java.net/browse/JDK-6826074)が原因(`HeavyWeight`、`LightWeight`だけではなくレイアウトがうまく更新されていない？)のようです。`JViewport#setViewPosition(...)`をオーバーライドして`revalidate()`すれば、`1.7.0`と同様の動作をするようになりました。 -- *aterai* 2013-08-19 (月) 14:43:11
- `Highlighter.Highlight#getStartOffset()`を使用するように変更。 -- *aterai* 2013-08-23 (金) 16:14:35

<!-- dummy comment line for breaking list -->
