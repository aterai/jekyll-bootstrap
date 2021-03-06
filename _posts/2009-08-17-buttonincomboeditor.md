---
layout: post
category: swing
folder: ButtonInComboEditor
title: JComboBoxのEditorComponentにJButtonを配置
tags: [JComboBox, LayoutManager, JButton, JLabel, Icon, RGBImageFilter, RescaleOp]
author: aterai
pubdate: 2009-08-17T12:55:55+09:00
description: JComboBoxのEditorComponentにJButtonやJLabelなどを配置します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIT4iCWGI/AAAAAAAAASk/pFFcvRBoyIg/s800/ButtonInComboEditor.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/08/jbutton-in-comboeditor.html
    lang: en
comments: true
---
## 概要
`JComboBox`の`EditorComponent`に`JButton`や`JLabel`などを配置します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIT4iCWGI/AAAAAAAAASk/pFFcvRBoyIg/s800/ButtonInComboEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class SiteComboBoxLayout implements LayoutManager {
  private final JLabel favicon;
  private final JButton feedButton;
  protected SiteComboBoxLayout(JLabel favicon, JButton feedButton) {
    this.favicon = favicon;
    this.feedButton = feedButton;
  }
  @Override public void addLayoutComponent(String name, Component comp) {
    /* not needed */
  }
  @Override public void removeLayoutComponent(Component comp) {
    /* not needed */
  }
  @Override public Dimension preferredLayoutSize(Container parent) {
    return parent.getPreferredSize();
  }
  @Override public Dimension minimumLayoutSize(Container parent) {
    return parent.getMinimumSize();
  }
  @Override public void layoutContainer(Container parent) {
    if (!(parent instanceof JComboBox)) {
      return;
    }
    JComboBox&lt;?&gt; cb = (JComboBox&lt;?&gt;) parent;
    int width = cb.getWidth();
    int height = cb.getHeight();
    Insets insets = cb.getInsets();
    int arrowHeight = height - insets.top - insets.bottom;
    int arrowWidth = arrowHeight;
    int faviconWidth = arrowHeight;
    int feedWidth; // = arrowHeight;

    // Arrow Icon JButton
    JButton arrowButton = (JButton) cb.getComponent(0);
    if (Objects.nonNull(arrowButton)) {
      Insets arrowInsets = arrowButton.getInsets();
      arrowWidth = arrowButton.getPreferredSize().width
        + arrowInsets.left + arrowInsets.right;
      arrowButton.setBounds(width - insets.right - arrowWidth, insets.top,
                            arrowWidth, arrowHeight);
    }

    // Favicon JLabel
    if (Objects.nonNull(favicon)) {
      Insets faviconInsets = favicon.getInsets();
      faviconWidth = favicon.getPreferredSize().width
          + faviconInsets.left + faviconInsets.right;
      favicon.setBounds(insets.left, insets.top, faviconWidth, arrowHeight);
    }

    // Feed Icon JButton
    if (Objects.nonNull(feedButton) &amp;&amp; feedButton.isVisible()) {
      Insets feedInsets = feedButton.getInsets();
      feedWidth = feedButton.getPreferredSize().width
          + feedInsets.left + feedInsets.right;
      feedButton.setBounds(width - insets.right - feedWidth - arrowWidth, insets.top,
                           feedWidth, arrowHeight);
    } else {
      feedWidth = 0;
    }

    // JComboBox Editor
    Component editor = cb.getEditor().getEditorComponent();
    if (Objects.nonNull(editor)) {
      editor.setBounds(insets.left + faviconWidth, insets.top,
          width  - insets.left - insets.right - arrowWidth - faviconWidth - feedWidth,
          height - insets.top  - insets.bottom);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`に独自のレイアウトマネージャーを設定して、そのエディタ内部にデフォルトの`ArrowButton`とは異なる`JButton`や`JLabel`を追加で配置しています。

- `JButton`に`Feed`アイコンを設定して、`ArrowButton`の左側に追加配置
    - `EditorComponent`にフォーカスがある場合、この`FeedButton`は非表示
- `JLabel`に`Favicon`を設定して、左端に追加配置

<!-- dummy comment line for breaking list -->

- - - -
`RolloverIcon`は、元のアイコンに以下のようなフィルタを掛けて作成しています。

<pre class="prettyprint"><code>// RGBImageFilter を使用
private static ImageIcon makeFilteredImage(ImageIcon srcIcon) {
  RGBImageFilter filter = new SelectedImageFilter();
  FilteredImageSource fis = new FilteredImageSource(srcIcon.getImage().getSource(), filter);
  return new ImageIcon(Toolkit.getDefaultToolkit().createImage(fis));
}
class SelectedImageFilter extends RGBImageFilter {
  private static final float SCALE = 1.2f;
  @Override public int filterRGB(int x, int y, int argb) {
    //int a = (argb &gt;&gt; 24) &amp; 0xFF;
    int r = (int) Math.min(0xFF, ((argb &gt;&gt; 16) &amp; 0xFF) * SCALE);
    int g = (int) Math.min(0xFF, ((argb &gt;&gt;  8) &amp; 0xFF) * SCALE);
    int b = (int) Math.min(0xFF, ((argb)       &amp; 0xFF) * SCALE);
    return (argb &amp; 0xFF_00_00_00) | (r &lt;&lt; 16) | (g &lt;&lt; 8) | (b);
  }
}

// RescaleOp を使用
private static ImageIcon makeFilteredImage2(ImageIcon srcIcon) {
  RescaleOp op = new RescaleOp(
      new float[] { 1.2f, 1.2f, 1.2f, 1f },
      new float[] { 0f, 0f, 0f, 0f }, null);
  BufferedImage img = new BufferedImage(
      srcIcon.getIconWidth(), srcIcon.getIconHeight(), BufferedImage.TYPE_INT_ARGB);
  Graphics g = img.getGraphics();
  //g.drawImage(srcIcon.getImage(), 0, 0, null);
  srcIcon.paintIcon(null, g, 0, 0);
  g.dispose();
  return new ImageIcon(op.filter(img, null));
}
</code></pre>

## 参考リンク
- [Feed Icons - Home of the Standard Web Feed Icon](http://feedicons.com/)
- [JComboBoxにアイコンを表示](https://ateraimemo.com/Swing/IconComboBox.html)
- [JTextField内にアイコンを追加](https://ateraimemo.com/Swing/IconTextField.html)

<!-- dummy comment line for breaking list -->

## コメント
- `EditorComponent`に追加した`JButton`をクリックすると例外が発生する場合があるバグを修正 -- *aterai* 2009-08-28 (金) 16:42:47

<!-- dummy comment line for breaking list -->
