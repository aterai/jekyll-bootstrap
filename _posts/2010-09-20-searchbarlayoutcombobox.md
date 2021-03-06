---
layout: post
category: swing
folder: SearchBarLayoutComboBox
title: JComboBox内にJButtonを左右に二つレイアウトする
tags: [JComboBox, JButton, ArrowButton, LayoutManager, JTextField, PopupMenuListener]
author: aterai
pubdate: 2010-09-20T12:16:36+09:00
description: JComboBoxが使用するレイアウトを変更して、検索欄風のコンポーネントを作成します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSqLxrLoI/AAAAAAAAAjI/M2OZzogy3-Q/s800/SearchBarLayoutComboBox.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2010/09/searchbar-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`が使用するレイアウトを変更して、検索欄風のコンポーネントを作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSqLxrLoI/AAAAAAAAAjI/M2OZzogy3-Q/s800/SearchBarLayoutComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>public class BasicSearchBarComboBoxUI extends SearchBarComboBoxUI {
  protected boolean isEditable = true;
  public static javax.swing.plaf.ComponentUI createUI(JComponent c) {
    return new BasicSearchBarComboBoxUI();
  }

  @Override protected void installDefaults() {
    super.installDefaults();
    // comboBox.setEditable(true);
    comboBox.putClientProperty("JComboBox.isTableCellEditor", Boolean.TRUE);
    // comboBox.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
  }

  @Override protected LayoutManager createLayoutManager() {
    return new LayoutManager() {
      @Override public void addLayoutComponent(String name, Component comp) {}
      @Override public void removeLayoutComponent(Component comp) {}
      @Override public Dimension preferredLayoutSize(Container parent) {
        return parent.getPreferredSize();
      }
      @Override public Dimension minimumLayoutSize(Container parent) {
        return parent.getMinimumSize();
      }
      @Override public void layoutContainer(Container parent) {
        if (!(parent instanceof JComboBox)) return;
        JComboBox cb     = (JComboBox) parent;
        int width        = cb.getWidth();
        int height       = cb.getHeight();
        Insets insets    = cb.getInsets();
        int buttonHeight = height - (insets.top + insets.bottom);
        int buttonWidth  = buttonHeight;
        int loupeWidth   = buttonHeight;

        JButton arrowButton = (JButton) cb.getComponent(0);
        if (arrowButton != null) {
          Insets arrowInsets = arrowButton.getInsets();
          buttonWidth = arrowButton.getPreferredSize().width +
            arrowInsets.left + arrowInsets.right;
          arrowButton.setBounds(insets.left, insets.top, buttonWidth, buttonHeight);
        }
        JButton loupeButton = null;
        for (Component c: cb.getComponents()) {
          if ("ComboBox.loupeButton".equals(c.getName())) {
            loupeButton = (JButton) c;
            break;
          }
        }
        // = (JButton) cb.getComponent(3);
        if (loupeButton != null) {
          Insets loupeInsets = loupeButton.getInsets();
          loupeWidth = loupeButton.getPreferredSize().width +
            loupeInsets.left + loupeInsets.right;
          loupeButton.setBounds(width - (insets.right + loupeWidth),
                                insets.top, loupeWidth, buttonHeight);
        }
        JTextField editor = (JTextField) cb.getEditor().getEditorComponent();
        // JTextField editor = (JTextField) cb.getComponent(1);
        if (editor != null) {
          editor.setBounds(insets.left + buttonWidth, insets.top,
               width  - (insets.left + insets.right + buttonWidth + loupeWidth),
               height - (insets.top  + insets.bottom));
        }
      }
    };
  }
  // ...
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`が使用する`LayoutManager`を以下のように変更しています。

- `ArrowButton`は右側から左側に移動
    - `JComboBox#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);`とした場合のコードを流用
    - 検索サイトのアイコンと下向きの三角の二つを表示するように設定
- `LoupeButton`として新たに`JButton`を追加し、右側に配置
- 常に編集可能として`JTextField`を中央に配置
- ポップアップを表示、選択しても`JTextField`が変更されないように設定
    - `JComboBox#putClientProperty("JComboBox.isTableCellEditor", Boolean.TRUE);`として、カーソル移動で変更されないように設定
    - 選択されても`PopupMenuListener`で`setText(...)`し直すように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>protected PopupMenuListener createPopupMenuListener() {
  if (popupMenuListener == null) {
    popupMenuListener = new PopupMenuListener() {
      private String str;
      @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
        JComboBox combo = (JComboBox) e.getSource();
        str = combo.getEditor().getItem().toString();
      }
      @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
        Object o = listBox.getSelectedValue();
        if (o instanceof SearchEngine) {
          SearchEngine se = (SearchEngine) o;
          arrowButton.setIcon(se.favicon);
        }
        JComboBox combo = (JComboBox) e.getSource();
        combo.getEditor().setItem(str);
      }
      @Override public void popupMenuCanceled(PopupMenuEvent e) {}
    };
  }
  return popupMenuListener;
}
</code></pre>

## 参考リンク
- [JComboBoxのArrowButtonを隠す](https://ateraimemo.com/Swing/HideComboArrowButton.html)

<!-- dummy comment line for breaking list -->

## コメント
- `editor`にフォーカスがある場合、左のボタンをクリックしてもポップアップメニューが開かないバグを修正。 -- *aterai* 2010-09-24 (金) 20:20:42
- `ArrowButton`をクリックして、カーソルキーを押すと`NullPointerException`が発生するバグを修正(この修正？で、ポップアップが表示されている状態で、例えば<kbd>G</kbd>キーを押しても、項目の`google`は選択されなくなった)。 -- *aterai* 2011-01-07 (金) 16:29:00
- `LookAndFeel`を切り替えると、`JComboBox`のフォント設定で、`NullPointerException`が発生するのを修正。 -- *aterai* 2011-05-25 (水) 17:46:55

<!-- dummy comment line for breaking list -->
