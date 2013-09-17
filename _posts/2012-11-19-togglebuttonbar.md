---
layout: post
title: JRadioButtonを使ってToggleButtonBarを作成
category: swing
folder: ToggleButtonBar
tags: [JRadioButton, Icon, Path2D]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-11-19

## JRadioButtonを使ってToggleButtonBarを作成
`JRadioButton`のアイコンを変更して、`ToggleButtonBar`を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-5-1KU3hp2co/UKjlTJyKvRI/AAAAAAAABW8/QuYQcKDeeyM/s800/ToggleButtonBar.png)

### サンプルコード
<pre class="prettyprint"><code>class ToggleButtonBarCellIcon implements Icon{
  private static final Color TL = new Color(1f,1f,1f,.2f);
  private static final Color BR = new Color(0f,0f,0f,.2f);
  private static final Color ST = new Color(1f,1f,1f,.4f);
  private static final Color SB = new Color(1f,1f,1f,.1f);

  private Color ssc;
  private Color bgc;

  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    int r = 8;
    int w = c.getWidth();
    int h = c.getHeight();

    Container parent = c.getParent();
    if(parent==null) {
      return;
    }

    Graphics2D g2 = (Graphics2D)g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    Path2D.Float p = new Path2D.Float();

    if(c==parent.getComponent(0)) {
      //:first-child
      p.moveTo(x, y + r);
      p.quadTo(x, y, x + r, y);
      p.lineTo(x + w, y);
      p.lineTo(x + w, y + h);
      p.lineTo(x + r, y + h);
      p.quadTo(x, y + h, x, y + h - r);
    }else if(c==parent.getComponent(parent.getComponentCount()-1)) {
      //:last-child
      p.moveTo(x, y);
      p.lineTo(x + w - r, y);
      p.quadTo(x + w, y, x + w, y + r);
      p.lineTo(x + w, y + h - r);
      p.quadTo(x + w, y + h, x + w -r, y + h);
      p.lineTo(x, y + h);
    }else{
      p.moveTo(x, y);
      p.lineTo(x + w, y);
      p.lineTo(x + w, y + h);
      p.lineTo(x, y + h);
    }
    p.closePath();
    Area area = new Area(p);

    g2.setPaint(c.getBackground());
    g2.fill(area);

    ssc = TL;
    bgc = BR;
    if(c instanceof AbstractButton) {
      ButtonModel m = ((AbstractButton)c).getModel();
      if(m.isSelected() || m.isRollover()) {
        ssc = ST;
        bgc = SB;
      }
    }
    g2.setPaint(new GradientPaint(x, y, ssc, x, y+h, bgc, true));
    g2.fill(area);

    g2.setPaint(BR);
    g2.draw(area);

    g2.dispose();
  }
  @Override public int getIconWidth()  {
    return 80;
  }
  @Override public int getIconHeight() {
    return 20;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JRadioButton`に選択またはロールオーバーでグラデーションが変化する`Icon`を設定し、これらを`ButtonGroup`に追加することで、`ToggleButtonBar`を作成しています。

- 配色は、[簡単、きれい！RGBaカラーを使って横メニューを作ってみる｜Webpark](http://weboook.blog22.fc2.com/blog-entry-342.html) をそのまま引用
- `JRadioButton`のサイズは`Icon`のサイズと等しくなるように、テキストとアイコンは中央揃えで重ねて表示し、`Border`も`0`に設定
    - `GridLayout`の水平間隔なども`0`にして隙間ができないように配置
- 最初の`JRadioButton`は左、最後の`JRadioButton`は右の角を丸める
    - 参考: [JComboBoxの角を丸める](http://terai.xrea.jp/Swing/RoundedComboBox.html)
    - `JRadioButton#setContentAreaFilled(false)`として、描画をすべてアイコンで行う(角を丸めた時に背景色を描画しないように)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [簡単、きれい！RGBaカラーを使って横メニューを作ってみる｜Webpark](http://weboook.blog22.fc2.com/blog-entry-342.html)
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](http://terai.xrea.jp/Swing/CardLayoutTabbedPane.html)
- [JComboBoxの角を丸める](http://terai.xrea.jp/Swing/RoundedComboBox.html)

<!-- dummy comment line for breaking list -->

### コメント
