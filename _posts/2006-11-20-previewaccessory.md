---
layout: post
title: JFileChooserに画像プレビューを追加
category: swing
folder: PreviewAccessory
tags: [JFileChooser, ImageIcon, PropertyChangeListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-11-20

## JFileChooserに画像プレビューを追加
`JFileChooser`に画像のプレビュー機能を追加します。プレビューを表示するコンポーネントは、チュートリアルの[ImagePreview.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/FileChooserDemo2Project/src/components/ImagePreview.java)をそのまま利用しています。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRN6_UpeI/AAAAAAAAAg0/eJZas5kcb34/s800/PreviewAccessory.png)

### サンプルコード
<pre class="prettyprint"><code>fileChooser = new JFileChooser();
fileChooser.setAccessory(new ImagePreview(fileChooser));
//...

//http://docs.oracle.com/javase/tutorial/uiswing/examples/components/FileChooserDemo2Project/src/components/ImagePreview.java
class ImagePreview extends JComponent implements PropertyChangeListener {
  private static final int PREVIEW_WIDTH  = 90;
  private static final int PREVIEW_MARGIN = 5;
  private ImageIcon thumbnail = null;
  private File file = null;
  public ImagePreview(JFileChooser fc) {
    setPreferredSize(new Dimension(PREVIEW_WIDTH+PREVIEW_MARGIN*2, 50));
    fc.addPropertyChangeListener(this);
  }
  public void loadImage() {
    if(file == null) {
      thumbnail = null;
      return;
    }
    ImageIcon tmpIcon = new ImageIcon(file.getPath());
    if(tmpIcon.getIconWidth()&gt;PREVIEW_WIDTH) {
      //Image img = tmpIcon.getImage().getScaledInstance(
      //     PREVIEW_WIDTH,-1,Image.SCALE_DEFAULT);
      //The Perils of Image.getScaledInstance() | Java.net
      //http://today.java.net/pub/a/today/2007/04/03/perils-of-image-getscaledinstance.html
      float scale = PREVIEW_WIDTH/(float)tmpIcon.getIconWidth();
      int newW = (int)(tmpIcon.getIconWidth()  * scale);
      int newH = (int)(tmpIcon.getIconHeight() * scale);
      BufferedImage img = new BufferedImage(newW, newH, BufferedImage.TYPE_INT_ARGB);
      Graphics2D g2 = (Graphics2D)img.getGraphics();
      g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                          RenderingHints.VALUE_INTERPOLATION_BILINEAR);
      g2.drawImage(tmpIcon.getImage(), 0, 0, newW, newH, null);
      g2.dispose();
      thumbnail = new ImageIcon(img);
    }else{
      thumbnail = tmpIcon;
    }
  }
  @Override public void propertyChange(PropertyChangeEvent e) {
    boolean update = false;
    String prop = e.getPropertyName();
    if(JFileChooser.DIRECTORY_CHANGED_PROPERTY.equals(prop)) {
      file = null;
      update = true;
    }else if(JFileChooser.SELECTED_FILE_CHANGED_PROPERTY.equals(prop)) {
      file = (File)e.getNewValue();
      update = true;
    }
    if(update) {
      thumbnail = null;
      if(isShowing()) {
        loadImage();
        repaint();
      }
    }
  }
  @Override protected void paintComponent(Graphics g) {
    if(thumbnail==null) {
      loadImage();
    }
    if(thumbnail!=null) {
      int x = getWidth()/2  - thumbnail.getIconWidth()/2;
      int y = getHeight()/2 - thumbnail.getIconHeight()/2;
      if(y &lt; 0)              y = 0;
      if(x &lt; PREVIEW_MARGIN) x = PREVIEW_MARGIN;
      thumbnail.paintIcon(this, g, x, y);
    }
  }
}
</code></pre>

### 解説
上記のファイルチューザーでは、画像ファイルを選択すると、そのプレビューが表示されます。プレビューコンポーネントは、`JFileChooser#setAccessory(JComponent)`メソッドで、ファイルチューザーに追加しています。

プレビュー側でファイルの選択、解除などのイベントを受け取るために、`PropertyChangeListener`を実装する必要があります。

### 参考リンク
- [How to Use File Choosers (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/filechooser.html)
- [デジタル出力工房　絵写楽](http://www.bekkoame.ne.jp/~bootan/free2.html)

<!-- dummy comment line for breaking list -->

### コメント
