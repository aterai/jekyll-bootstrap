---
layout: post
title: JComboBoxのEditorComponentにJButtonを配置
category: swing
folder: ButtonInComboEditor
tags: [JComboBox, LayoutManager, JButton, JLabel, Icon, RGBImageFilter, RescaleOp]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-08-17

## JComboBoxのEditorComponentにJButtonを配置
`JComboBox`の`EditorComponent`に`JButton`や`JLabel`などを配置します。


{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIT4iCWGI/AAAAAAAAASk/pFFcvRBoyIg/s800/ButtonInComboEditor.png %}

### サンプルコード
<pre class="prettyprint"><code>combo02.setLayout(new LayoutManager() {
  @Override public void addLayoutComponent(String name, Component comp) {}
  @Override public void removeLayoutComponent(Component comp) {}
  @Override public Dimension preferredLayoutSize(Container parent) {
    return parent.getPreferredSize();
  }
  @Override public Dimension minimumLayoutSize(Container parent) {
    return parent.getMinimumSize();
  }
  @Override public void layoutContainer(Container parent) {
    if(!(parent instanceof JComboBox)) return;
    JComboBox cb   = (JComboBox)parent;
    int width    = cb.getWidth();
    int height     = cb.getHeight();
    Insets insets  = cb.getInsets();
    int buttonHeight = height - (insets.top + insets.bottom);
    int buttonWidth  = buttonHeight;
    int labelWidth   = buttonHeight;
    int loupeWidth   = buttonHeight;

    JButton arrowButton = (JButton)cb.getComponent(0);
    if(arrowButton != null) {
      Insets arrowInsets = arrowButton.getInsets();
      buttonWidth = arrowButton.getPreferredSize().width
        + arrowInsets.left + arrowInsets.right;
      arrowButton.setBounds(width - (insets.right + buttonWidth),
                            insets.top, buttonWidth, buttonHeight);
    }
    if(label != null) {
      Insets labelInsets = label.getInsets();
      labelWidth = label.getPreferredSize().width
        + labelInsets.left + labelInsets.right;
      label.setBounds(insets.left, insets.top, labelWidth, buttonHeight);
    }
    JButton rssButton = button;
    if(rssButton != null &amp;&amp; rssButton.isVisible()) {
      Insets loupeInsets = rssButton.getInsets();
      loupeWidth = rssButton.getPreferredSize().width
        + loupeInsets.left + loupeInsets.right;
      rssButton.setBounds(width - (insets.right + loupeWidth + buttonWidth),
                          insets.top, loupeWidth, buttonHeight);
    }else{
      loupeWidth = 0;
    }

    Component editor = cb.getEditor().getEditorComponent();
    if ( editor != null ) {
      editor.setBounds(insets.left + labelWidth, insets.top,
        width -(insets.left+insets.right+buttonWidth+labelWidth+loupeWidth),
        height-(insets.top +insets.bottom));
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JComboBox`に独自のレイアウトマネージャーを設定して、`JButton`や`JLabel`を配置しています。

- - - -
`RolloverIcon`は、元のアイコンに以下のようなフィルタを掛けて作成しています。

- `RGBImageFilter`を使用

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static ImageIcon makeFilteredImage(ImageIcon srcIcon) {
  RGBImageFilter filter = new SelectedImageFilter();
  FilteredImageSource fis = new FilteredImageSource(srcIcon.getImage().getSource(), filter);
  return new ImageIcon(Toolkit.getDefaultToolkit().createImage(fis));
}
static class SelectedImageFilter extends RGBImageFilter {
  public SelectedImageFilter() {
    canFilterIndexColorModel = false;
  }
  private final float scale = 1.2f;
  public int filterRGB(int x, int y, int argb) {
    //int a = (argb &gt;&gt; 24) &amp; 0xff;
    int r = (argb &gt;&gt; 16) &amp; 0xff;
    int g = (argb &gt;&gt; 8)  &amp; 0xff;
    int b = (argb)       &amp; 0xff;
    r = (int)(r*scale);
    g = (int)(g*scale);
    b = (int)(b*scale);
    if(r &gt; 255) r = 255;
    if(g &gt; 255) g = 255;
    if(b &gt; 255) b = 255;
    return (argb &amp; 0xff000000) | (r&lt;&lt;16) | (g&lt;&lt;8) | (b);
  }
}
</code></pre>

- `RescaleOp`を使用

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static ImageIcon makeFilteredImage2(ImageIcon srcIcon) {
  RescaleOp op = new RescaleOp(
      new float[] { 1.2f,1.2f,1.2f,1.0f },
      new float[] { 0f,0f,0f,0f }, null);
  BufferedImage img = new BufferedImage(
      srcIcon.getIconWidth(), srcIcon.getIconHeight(), BufferedImage.TYPE_INT_ARGB);
  Graphics g = img.getGraphics();
  //g.drawImage(srcIcon.getImage(), 0, 0, null);
  srcIcon.paintIcon(null, g, 0, 0);
  g.dispose();
  return new ImageIcon(op.filter(img, null));
}
</code></pre>

### 参考リンク
- [Feed Icons - Home of the Standard Web Feed Icon](http://feedicons.com/)
- [JComboBoxにアイコンを表示](http://terai.xrea.jp/Swing/IconComboBox.html)
- [JTextField内にアイコンを追加](http://terai.xrea.jp/Swing/IconTextField.html)

<!-- dummy comment line for breaking list -->

### コメント
- `EditorComponent`に追加した`JButton`をクリックすると例外が発生する場合があるバグを修正 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-08-28 (金) 16:42:47

<!-- dummy comment line for breaking list -->

