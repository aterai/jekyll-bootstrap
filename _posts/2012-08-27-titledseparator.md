---
layout: post
title: TitledBorderとMatteBorderを使用してTitledSeparatorを作成する
category: swing
folder: TitledSeparator
tags: [JSeparator, TitledBorder, MatteBorder, JLabel, Icon, LinearGradientPaint]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-08-27

## TitledBorderとMatteBorderを使用してTitledSeparatorを作成する
`TitledBorder`と`MatteBorder`を使用して`Title`付きの`Separator`を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-sRtVayYL37Q/UDs_iiXRk7I/AAAAAAAABRk/71qZoe9vM60/s800/TitledSeparator.png)

### サンプルコード
<pre class="prettyprint"><code>class TitledSeparator extends JLabel{
  private Color color;
  private final String title;
  private final Color target;
  private final int height;
  private final int titlePosition;
  public TitledSeparator(String title, int height, int titlePosition) {
    this(title, null, height, titlePosition);
  }
  public TitledSeparator(String _title, Color _target, int _height, int _titlePosition) {
    super();
    this.title = _title;
    this.target = _target;
    this.height = _height;
    this.titlePosition = _titlePosition;
    Icon icon = new Icon() {
      private int width = -1;
      private Paint painter1, painter2;
      @Override public void paintIcon(Component c, Graphics g, int x, int y) {
        int w = c.getWidth();
        if(w!=width || painter1==null || painter2==null || color==null) {
          width = w;
          Point2D start = new Point2D.Float(0f, 0f);
          Point2D end   = new Point2D.Float((float)width, 0f);
          float[] dist  = {0.0f, 1.0f};
          color = getBackground();
          color = color==null ? UIManager.getColor("Panel.background") : color;
          Color tc = target==null ? color : target;
          painter1 = new LinearGradientPaint(start, end, dist, new Color[] {tc.darker(),   color});
          painter2 = new LinearGradientPaint(start, end, dist, new Color[] {tc.brighter(), color});
        }
        int h = getIconHeight()/2;
        Graphics2D g2  = (Graphics2D)g.create();
        g2.setPaint(painter1);
        g2.fillRect(x, y,   width, getIconHeight());
        g2.setPaint(painter2);
        g2.fillRect(x, y+h, width, getIconHeight()-h);
        g2.dispose();
      }
      @Override public int getIconWidth()  { return 200; } //dummy width
      @Override public int getIconHeight() { return height; }
    };
    this.setBorder(BorderFactory.createTitledBorder(
      BorderFactory.createMatteBorder(height, 0, 0, 0, icon), title,
      TitledBorder.DEFAULT_JUSTIFICATION, titlePosition));
    //System.out.println(getInsets());
  }
  @Override public Dimension getMaximumSize() {
    Dimension d = super.getPreferredSize();
    d.width = Short.MAX_VALUE;
    return d;
  }
  @Override public void updateUI() {
    super.updateUI();
    color = null;
  }
}
</code></pre>

### 解説
`TitledBorder`と、左下右の`Insets`が`0`(上余白のみ設定)でタイルアイコンでグラデーションを行う`MatteBorder`を組み合わせ、これを空の`JLabel`に設定することで、`TitledSeparator`を作成しています。

- 上
    - タイトルの垂直位置をデフォルトの`TitledBorder.DEFAULT_POSITION`にして、`Separator`上に重なるように表示
    - `Java 1.6.0`では、タイトルの上に`Separator`が表示される場合がある？(`1.7.0`では正常)
- 中
    - タイトルの垂直位置が上(`TitledBorder.ABOVE_TOP`)で、`Separator`の上に表示
- 下
    - `JSeparator`を使用

<!-- dummy comment line for breaking list -->

- - - -
注: 縦のセパレーターには未対応

### 参考リンク
- [TitledBorderのタイトル位置](http://terai.xrea.jp/Swing/TitledBorder.html)
- [Separatorのグラデーション](http://terai.xrea.jp/Swing/Gradient.html)

<!-- dummy comment line for breaking list -->

### コメント
