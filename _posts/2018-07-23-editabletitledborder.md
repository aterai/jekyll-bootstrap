---
layout: post
category: swing
folder: EditableTitledBorder
title: TitledBorderのタイトルを直接編集する
tags: [TitledBorder, GlassPane, JTextField]
author: aterai
pubdate: 2018-07-23T17:10:16+09:00
description: TitledBorderのタイトルをダブルクリックすると、GlassPaneに配置したJTextFieldをその上に表示して文字列を編集可能にします。
image: https://drive.google.com/uc?id=1Js7r-iMG7F3VdWkVGB0A6jcfSadZCxBz3A
comments: true
---
## 概要
`TitledBorder`のタイトルをダブルクリックすると、`GlassPane`に配置した`JTextField`をその上に表示して文字列を編集可能にします。

{% download https://drive.google.com/uc?id=1Js7r-iMG7F3VdWkVGB0A6jcfSadZCxBz3A %}

## サンプルコード
<pre class="prettyprint"><code>class EditableTitledBorder extends TitledBorder implements MouseListener {
  protected final Container glassPane = new EditorGlassPane();
  protected final JTextField editor = new JTextField();
  protected final JLabel dummy = new JLabel();
  protected final Rectangle rect = new Rectangle();
  protected Component comp;

  protected final Action startEditing = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      if (comp instanceof JComponent) {
        Optional.ofNullable(((JComponent) comp).getRootPane())
        .ifPresent(r -&gt; r.setGlassPane(glassPane));
      }
      glassPane.add(editor);
      glassPane.setVisible(true);

      Point p = SwingUtilities.convertPoint(comp, rect.getLocation(), glassPane);
      rect.setLocation(p);
      rect.grow(2, 2);
      editor.setBounds(rect);
      editor.setText(getTitle());
      editor.selectAll();
      editor.requestFocusInWindow();
    }
  };
  protected final Action cancelEditing = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      glassPane.setVisible(false);
    }
  };
  protected final Action renameTitle = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      if (!editor.getText().trim().isEmpty()) {
        setTitle(editor.getText());
      }
      glassPane.setVisible(false);
    }
  };
  // ...
</code></pre>

## 解説
上記のサンプルでは、`TitledBorder`のタイトルをマウスでダブルクリックすると、`GlassPane`に配置した`JTextField`を重ねて表示されてタイトル文字列が編集可能になります。

- タイトル文字列をダブルクリックで編集開始
- `JTextField`にフォーカスがある状態で<kbd>Enter</kbd>キーを入力すると編集完了
- `JTextField`にフォーカスがある状態で<kbd>ESC</kbd>キーで編集をキャンセル

<!-- dummy comment line for breaking list -->

- - - -
- `TitledBorder`のタイトルは`JLabel`で表示されているが、`private`なのでその位置やサイズの取得が不可
- 以下のように`TitledBorder#paintBorder(...)`メソッドから、`JLabel`の位置、サイズを計算しているコードを抜き出してその領域を取得
- 所得した領域内でダブルクリックされたら編集を開始し、`JTextField`の表示位置とサイズをその領域に合わせて`GlassPane`上に表示

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private Rectangle getTitleBounds(Component c, int x, int y, int width, int height) {
  String title = getTitle();
  if (Objects.nonNull(title) &amp;&amp; !title.isEmpty()) {
    Border border = getBorder();
    int edge = border instanceof TitledBorder ? 0 : EDGE_SPACING;
    JLabel label = getLabel(c);
    Dimension size = label.getPreferredSize();
    Insets insets = makeBorderInsets(border, c, new Insets(0, 0, 0, 0));

    int labelY = y;
    int labelH = size.height;
    int position = getTitlePosition();
    switch (position) {
    case ABOVE_TOP:
      insets.left = 0;
      insets.right = 0;
      break;
    case TOP:
      insets.top = edge + insets.top / 2 - labelH / 2;
      if (insets.top &gt;= edge) {
        labelY += insets.top;
      }
      break;
    case BELOW_TOP:
      labelY += insets.top + edge;
      break;
    case ABOVE_BOTTOM:
      labelY += height - labelH - insets.bottom - edge;
      break;
    case BOTTOM:
      labelY += height - labelH;
      insets.bottom = edge + (insets.bottom - labelH) / 2;
      if (insets.bottom &gt;= edge) {
        labelY -= insets.bottom;
      }
      break;
    case BELOW_BOTTOM:
      insets.left = 0;
      insets.right = 0;
      labelY += height - labelH;
      break;
    default:
      break;
    }
    insets.left += edge + TEXT_INSET_H;
    insets.right += edge + TEXT_INSET_H;

    int labelX = x;
    int labelW = width - insets.left - insets.right;
    if (labelW &gt; size.width) {
      labelW = size.width;
    }
    switch (getJustification(c)) {
    case LEFT:
      labelX += insets.left;
      break;
    case RIGHT:
      labelX += width - insets.right - labelW;
      break;
    case CENTER:
      labelX += (width - labelW) / 2;
      break;
    default:
      break;
    }
    return new Rectangle(labelX, labelY, labelW, labelH);
  }
  return new Rectangle();
}
</code></pre>

## 参考リンク
- [JTabbedPaneのタブタイトルを変更](https://ateraimemo.com/Swing/EditTabTitle.html)
- [TitledBorderにタイトル文字列までの内余白を設定する](https://ateraimemo.com/Swing/TitledBorderHorizontalInsetOfText.html)

<!-- dummy comment line for breaking list -->

## コメント
