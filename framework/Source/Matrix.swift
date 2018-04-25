#if !os(Linux)
import QuartzCore
#endif

public struct Matrix4x4 {
    public enum Index {
        case row, column
    }

    public var m11:Float = 0, m12:Float = 0, m13:Float = 0, m14:Float = 0
    public var m21:Float = 0, m22:Float = 0, m23:Float = 0, m24:Float = 0
    public var m31:Float = 0, m32:Float = 0, m33:Float = 0, m34:Float = 0
    public var m41:Float = 0, m42:Float = 0, m43:Float = 0, m44:Float = 0

    public var rowMajorValues: [Float] {
        get {
            return [
                m11, m12, m13, m14,
                m21, m22, m23, m24,
                m31, m32, m33, m34,
                m41, m42, m43, m44
            ]
        } set {
            loadVariablesFromRowMajorValeues(rowMajorValues: newValue)
        }
    }

    public init() {

    }

    public init(rowMajorValues:[Float]) {
        loadVariablesFromRowMajorValeues(rowMajorValues: rowMajorValues)
    }

    private mutating func loadVariablesFromRowMajorValeues(rowMajorValues: [Float]) {
        guard rowMajorValues.count > 15 else { fatalError("Tried to initialize a 4x4 matrix with fewer than 16 values") }

        self.m11 = rowMajorValues[0]
        self.m12 = rowMajorValues[1]
        self.m13 = rowMajorValues[2]
        self.m14 = rowMajorValues[3]

        self.m21 = rowMajorValues[4]
        self.m22 = rowMajorValues[5]
        self.m23 = rowMajorValues[6]
        self.m24 = rowMajorValues[7]

        self.m31 = rowMajorValues[8]
        self.m32 = rowMajorValues[9]
        self.m33 = rowMajorValues[10]
        self.m34 = rowMajorValues[11]

        self.m41 = rowMajorValues[12]
        self.m42 = rowMajorValues[13]
        self.m43 = rowMajorValues[14]
        self.m44 = rowMajorValues[15]
    }

    public static let identity = Matrix4x4(rowMajorValues:[1.0, 0.0, 0.0, 0.0,
                                                           0.0, 1.0, 0.0, 0.0,
                                                           0.0, 0.0, 1.0, 0.0,
                                                           0.0, 0.0, 0.0, 1.0])

    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < 4 && column >= 0 && column < 4
    }

    public subscript(row: Int, column: Int) -> Float {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return rowMajorValues[(row * 4) + column]
        } set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            rowMajorValues[(row * 4) + column] = newValue
        }
    }

    public subscript(index: Int) -> Float {
        get {
            return rowMajorValues[index]
        } set {
            rowMajorValues[index] = newValue
        }
    }

    public subscript(type: Matrix4x4.Index, value: Int) -> [Float] {
        get {
            switch type {
            case .row:
                assert(indexIsValid(row: value, column: 0), "Index out of range")
                return Array(rowMajorValues[(value * 4)..<(value * 4) + 4])
            case .column:
                assert(indexIsValid(row: 0, column: value), "Index out of range")
                let column = (0..<4).map { (currentRow) -> Float in
                    let currentColumnIndex = currentRow * 4 + value
                    return rowMajorValues[currentColumnIndex]
                }
                return column
            }
        } set {
            switch type {
            case .row:
                for (column, element) in newValue.enumerated() {
                    rowMajorValues[(value * 4) + column] = element
                }
            case .column:
                for (row, element) in newValue.enumerated() {
                    rowMajorValues[(row * 4) + value] = element
                }
            }
        }
    }
}

public struct Matrix3x3 {
    public var m11:Float = 0, m12:Float = 0, m13:Float = 0
    public var m21:Float = 0, m22:Float = 0, m23:Float = 0
    public var m31:Float = 0, m32:Float = 0, m33:Float = 0

    public var rowMajorValues: [Float] {
        get {
            return [
                m11, m12, m13,
                m21, m22, m23,
                m31, m32, m33
            ]
        } set {
            loadVariablesFromRowMajorValeues(rowMajorValues: newValue)
        }
    }

    private mutating func loadVariablesFromRowMajorValeues(rowMajorValues: [Float]) {
        guard rowMajorValues.count > 8 else { fatalError("Tried to initialize a 4x4 matrix with fewer than 9 values") }

        self.m11 = rowMajorValues[0]
        self.m12 = rowMajorValues[1]
        self.m13 = rowMajorValues[2]

        self.m21 = rowMajorValues[3]
        self.m22 = rowMajorValues[4]
        self.m23 = rowMajorValues[5]

        self.m31 = rowMajorValues[6]
        self.m32 = rowMajorValues[7]
        self.m33 = rowMajorValues[8]
    }

    public init(rowMajorValues:[Float]) {
        guard rowMajorValues.count > 8 else { fatalError("Tried to initialize a 3x3 matrix with fewer than 9 values") }

        loadVariablesFromRowMajorValeues(rowMajorValues: rowMajorValues)
    }

    public static let identity = Matrix3x3(rowMajorValues:[1.0, 0.0, 0.0,
                                                           0.0, 1.0, 0.0,
                                                           0.0, 0.0, 1.0])

    public static let centerOnly = Matrix3x3(rowMajorValues:[0.0, 0.0, 0.0,
                                                             0.0, 1.0, 0.0,
                                                             0.0, 0.0, 0.0])

    public subscript(row: Int, column: Int) -> Float {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return rowMajorValues[(row * 3) + column]
        } set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            rowMajorValues[(row * 3) + column] = newValue
        }
    }

    public subscript(index: Int) -> Float {
        get {
            return rowMajorValues[index]
        } set {
            rowMajorValues[index] = newValue
        }
    }

    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < 3 && column >= 0 && column < 3
    }
}

#if !os(Linux)
public extension Matrix4x4 {
    public init (_ transform3D:CATransform3D) {
        self.m11 = Float(transform3D.m11)
        self.m12 = Float(transform3D.m12)
        self.m13 = Float(transform3D.m13)
        self.m14 = Float(transform3D.m14)

        self.m21 = Float(transform3D.m21)
        self.m22 = Float(transform3D.m22)
        self.m23 = Float(transform3D.m23)
        self.m24 = Float(transform3D.m24)

        self.m31 = Float(transform3D.m31)
        self.m32 = Float(transform3D.m32)
        self.m33 = Float(transform3D.m33)
        self.m34 = Float(transform3D.m34)

        self.m41 = Float(transform3D.m41)
        self.m42 = Float(transform3D.m42)
        self.m43 = Float(transform3D.m43)
        self.m44 = Float(transform3D.m44)
    }

    public init (_ transform:CGAffineTransform) {
        self.init(CATransform3DMakeAffineTransform(transform))
    }

    public init(orthographicMatrixLeft left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float, anchorTopLeft: Bool = false) {
        let r_l = right - left
        let t_b = top - bottom
        let f_n = far - near
        var tx = -(right + left) / (right - left)
        var ty = -(top + bottom) / (top - bottom)
        let tz = -(far + near) / (far - near)

        let scale:Float
        if (anchorTopLeft) {
            scale = 4.0
            tx = -1.0
            ty = -1.0
        } else {
            scale = 2.0
        }

        self.init(rowMajorValues:[
            scale / r_l, 0.0, 0.0, tx,
            0.0, scale / t_b, 0.0, ty,
            0.0, 0.0, scale / f_n, tz,
            0.0, 0.0, 0.0, 1.0])
    }
}
#endif

public func *(left: Matrix4x4, right: Matrix4x4) -> Matrix4x4 {
    var C = Matrix4x4()

    for i in 0..<4 {
        for j in 0..<4 {
            C[i, j] = left[.row, i].dot(right[.column, j])
        }
    }

    return C
}
