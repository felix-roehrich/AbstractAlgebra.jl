@testset "MPolyFactor" begin
   # not much to test because we would need working univariate factorization
   @testset "hlift_have_lcs" begin

      R, (x, y, z) = polynomial_ring(QQ, ["x", "y", "z"])

      fac = [y*x^2+z, (z+1)*x^3+x*y+z, (y*z+1)*x^2+1]

      ok, f = AbstractAlgebra.MPolyFactor.hlift_have_lcs(prod(fac),
                                          [x^2+1, 2*x^3+x+1, 2*x^2+1],
                                          [y, z+1, y*z+1],
                                          1, [2, 3], [QQ(1), QQ(1)])
      @test ok
      @test f == fac
   end

   @testset "hlift_bivar_combine" begin

      R, (x, y) = polynomial_ring(QQ, ["x", "y"])

      p = y*(y*x+1)*((y+1)*x+y)*((y+2)*x+y)

      ok, content, fac = AbstractAlgebra.MPolyFactor.hlift_bivar_combine(p,
                                            1, 2, QQ(1), [x+1, 2*x+1, 3*x+1])
      @test ok
      @test degrees(content) == [0, 1]
      @test p == content*prod(fac)
   end

   R, (x, y) = ZZ[:x,:y]
   f = x^2
   fa = AbstractAlgebra.MPolyFactor.mfactor_squarefree_char_zero(x^2)
   @test is_unit(unit(fa))
   @test length(fa) == 1 && f == unit(fa) * prod(p^e for (p, e) in fa)
   fa = AbstractAlgebra.MPolyFactor.mfactor_squarefree_char_zero(x^2)
   @test is_unit(unit(fa))
   @test length(fa) == 1 && f == unit(fa) * prod(p^e for (p, e) in fa)
end
